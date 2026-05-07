vim.api.nvim_create_autocmd("TermOpen", {
	callback = function(args)
		local current_buffer = vim.api.nvim_get_current_buf()
		local chan_id = vim.b.terminal_job_id
		if chan_id then

            if not vim.g.nvim_pipe_path or vim.g.nvim_pipe_path == "" then
                local pipe_path = "/tmp/" .. vim.fn.getpid() .. ".nvim.pipe"
                vim.g.nvim_pipe_path = pipe_path
                vim.fn.serverstart(pipe_path)
            end

            vim.api.nvim_chan_send(chan_id, "export NVIM_REMOTE_PIPE_PATH=" .. vim.g.nvim_pipe_path .. "\n")

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

            for _, file in ipairs(args) do
                local abs_file = vim.fn.fnamemodify(tostring(file), ":p")

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
            end

            vim.cmd("qa!")
        end,
    })
end
