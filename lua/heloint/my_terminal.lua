local terminals_by_tabpages = {}

function Toggle_terminal()
	-- If we don't have a toggleable terminal initialized, then we init one and return.
	local current_window = vim.api.nvim_get_current_win()
	local current_tabpage = vim.api.nvim_win_get_tabpage(current_window)
	local current_term_bufname = terminals_by_tabpages[current_tabpage]

	if current_term_bufname == nil or vim.fn.bufexists(current_term_bufname) == 0 then
		vim.cmd("botright sp | term")
		local current_buffer = vim.api.nvim_get_current_buf()
		current_term_bufname = vim.fn.bufname(current_buffer)
		terminals_by_tabpages[current_tabpage] = vim.fn.bufname(current_buffer)
		return
	end

	-- If we already have a initialized toggleable terminal and it's opened, then we close it.
	local windows = vim.api.nvim_list_wins()
	for _, win in ipairs(windows) do
		local buf = vim.api.nvim_win_get_buf(win)
		local bufname = vim.fn.bufname(buf)
		if bufname == current_term_bufname then
			vim.api.nvim_set_current_win(win)
			vim.cmd("q")
			return
		end
	end

	-- If we don't have an opened, but initialized toggleable terminal, then we open the buffer.
	vim.cmd("botright sp | b " .. current_term_bufname)
end

vim.keymap.set("n", "<space>t", Toggle_terminal, { desc = "Toggle horizontal split terminal pop-up." })
vim.keymap.set("t", "<Esc>", "<C-\\><C-N>", { silent = true, desc = "Return to normal mode in the integrated terminal." })


-- [[
-- Inherit the parent shell's venv for new terminals.
--]]
function handle_python_virtual_env_inherit(chan_id)
    local current_venv = vim.env.VIRTUAL_ENV
    if current_venv and current_venv ~= "" then
        local current_venv_activate_file = current_venv .. "/bin/activate"
        vim.api.nvim_chan_send(
            chan_id,
            "deactivate 2> /dev/null; source " .. current_venv_activate_file .. "\n"
        )
    end
end


-- [[
-- Handle server start for remote command listening.
-- This is necessary for things, like
-- avoiding the nested neovim instance opening inside the built-in terminal.
-- --]]
function handle_nvim_server_setup(chan_id)
    if not vim.g.nvim_pipe_path or vim.g.nvim_pipe_path == "" then
        local pipe_path = "/tmp/" .. vim.fn.getpid() .. ".nvim.pipe"
        vim.g.nvim_pipe_path = pipe_path
        vim.fn.serverstart(pipe_path)
    end

    vim.api.nvim_chan_send(chan_id, "export NVIM_REMOTE_PIPE_PATH=" .. vim.g.nvim_pipe_path .. "\n")
end


vim.api.nvim_create_autocmd("TermOpen", {
	callback = function(args)
		local current_buffer = vim.api.nvim_get_current_buf()
		local chan_id = vim.b.terminal_job_id
		if chan_id then
            handle_python_virtual_env_inherit(chan_id)
            handle_nvim_server_setup(chan_id)
		else
			print("Not in a terminal buffer")
		end
	end,
})


-- Redirect to parent neovim if launched from within a neovim built-in terminal.
-- The parent sets NVIM_REMOTE_PIPE_PATH in every terminal it spawns (see TermOpen below).
local _nvim_remote_pipe = vim.env.NVIM_REMOTE_PIPE_PATH
if _nvim_remote_pipe and _nvim_remote_pipe ~= "" then
    vim.api.nvim_create_autocmd("VimEnter", {
        once = true,
        callback = function()
            local args = vim.fn.argv()
            if #args == 0 then return end

            local pipe = _nvim_remote_pipe

            -- git difftool -x "nvim -d" invokes nvim with -d plus two file args.
            -- Detect this by checking vim.v.argv for the -d flag.
            local is_diff_mode = false
            for _, a in ipairs(vim.v.argv) do
                if a == "-d" or a == "--diff" then is_diff_mode = true; break end
            end

            if is_diff_mode and #args >= 2 then
                local file1 = vim.fn.fnamemodify(tostring(args[1]), ":p")
                local file2 = vim.fn.fnamemodify(tostring(args[2]), ":p")

                local sem = vim.fn.tempname()
                io.open(sem, "w"):close()

                -- Capture win1 (LOCAL) before the diffsplit moves the cursor to win2.
                -- WinClosed on win1 means the user closed or tabclosed the diff view.
                local lua_code =
                    'vim.cmd([[tabedit ' .. file1 .. ']]) ' ..
                    'local _w=tostring(vim.api.nvim_get_current_win()) ' ..
                    'vim.cmd([[vertical diffsplit ' .. file2 .. ']]) ' ..
                    'vim.api.nvim_create_autocmd("WinClosed",{pattern=_w,once=true,' ..
                    'callback=function() vim.fn.delete([[' .. sem .. ']]) end})'

                vim.fn.system({"nvim", "--server", pipe, "--remote-send",
                    "<C-\\><C-n>:lua " .. lua_code .. "<CR>"})

                vim.fn.system("while [ -f " .. vim.fn.shellescape(sem) .. " ]; do sleep 0.1; done")
            else
                for _, file in ipairs(args) do
                    local abs_file = vim.fn.fnamemodify(tostring(file), ":p")
                    -- Git always edits files inside the .git directory; block so git waits for the edit.
                    local should_block = abs_file:find("/.git/", 1, true) ~= nil

                    if should_block then
                        -- Semaphore file: parent deletes it when the editing window closes.
                        local sem = vim.fn.tempname()
                        io.open(sem, "w"):close()

                        -- Single :lua command sent to the parent so tabedit and win_getid()
                        -- are atomic — no race between opening the tab and capturing its ID.
                        -- WinClosed fires with the window-ID as its pattern, targeting exactly
                        -- this window and not any other.
                        local lua_code =
                            'vim.cmd([[tabedit ' .. abs_file .. ']]) ' ..
                            'local _w=tostring(vim.api.nvim_get_current_win()) ' ..
                            'vim.api.nvim_create_autocmd("WinClosed",{pattern=_w,once=true,' ..
                            'callback=function() vim.fn.delete([[' .. sem .. ']]) end})'

                        vim.fn.system({"nvim", "--server", pipe, "--remote-send",
                            "<C-\\><C-n>:lua " .. lua_code .. "<CR>"})

                        -- Block until the user closes that window (git waits for this process,
                        -- so each editor call — rebase-todo, commit message, etc. — blocks
                        -- independently until the user is done).
                        vim.fn.system("while [ -f " .. vim.fn.shellescape(sem) .. " ]; do sleep 0.1; done")
                    else
                        local lua_code = 'vim.cmd([[tabedit ' .. abs_file .. ']])'
                        vim.fn.system({"nvim", "--server", pipe, "--remote-send",
                            "<C-\\><C-n>:lua " .. lua_code .. "<CR>"})
                    end
                end
            end

            vim.cmd("qa!")
        end,
    })
end
