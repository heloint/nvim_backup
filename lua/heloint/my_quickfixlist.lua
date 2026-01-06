vim.api.nvim_create_autocmd('BufWinEnter', {
    group = vim.api.nvim_create_augroup('quickfix_list_base_group', { clear = true }),
    desc = 'allow updating quickfix window',
    pattern = 'quickfix',
    callback = function(args)
        vim.bo.modifiable = true
        -- :vimgrep's quickfix window display format now includes start and end column (in vim and nvim) so adding 2nd format to match that, also for 'grep -rin'
        vim.bo.errorformat = '%f|%l col %c| %m,%f|%l col %c-%k| %m,%f|%l| %m'
        vim.keymap.set(
            'n',
            '<C-s>',
            '<Cmd>cgetbuffer|set nomodified|echo "quickfix/location list updated"<CR>',
            { buffer = true, desc = 'Update quickfix/location list with changes made in quickfix window' }
        )
    end,
})

-- Toggle quickfix list on the bottom of the screen.
vim.keymap.set('n', '<C-q>', function()
    local qf_exists = false
    for _, win in pairs(vim.fn.getwininfo()) do
        if win["quickfix"] == 1 then
            qf_exists = true
        end
    end
    if qf_exists == true then
        vim.cmd "cclose"
        return
    end
    if not vim.tbl_isempty(vim.fn.getqflist()) then
        vim.cmd "copen"
        vim.cmd "set modifiable"
    end
end, {})



-- Quickfix float window with the quickfix value in it
local float_win = nil
local float_buf = nil
local qf_float_autogroup = vim.api.nvim_create_augroup("QuickfixFloat", { clear = true })
local qf_enabled = false -- <- default OFF

local function lstrip(s)
    return s:match("^%s*(.*)$")
end

local function get_qf_match_at_cursor()
    local qf = vim.fn.getqflist()
    if vim.tbl_isempty(qf) then
        return nil
    end

    local cur_buf = vim.api.nvim_get_current_buf()
    local cur_line = vim.api.nvim_win_get_cursor(0)[1]

    for _, item in ipairs(qf) do
        if item.bufnr == cur_buf and item.lnum == cur_line then
            return lstrip(item.text)
        end
    end

    return nil
end

local function close_qf_float_window()
    if float_win and vim.api.nvim_win_is_valid(float_win) then
        vim.api.nvim_win_close(float_win, true)
    end
    float_win = nil
    float_buf = nil
    vim.api.nvim_clear_autocmds({ group = qf_float_autogroup })
end

local function get_qf_float_text_and_size()
    local text = get_qf_match_at_cursor()
    if text == nil then return nil, 0 end

    local width = vim.fn.strdisplaywidth(text)
    width = math.max(width, 4)
    width = math.min(width, vim.o.columns - 4)

    return text, width
end

function update_qf_float()
    if not qf_enabled then return end -- <--- add this
    local text, width = get_qf_float_text_and_size()
    if text == nil then return end

    if float_win and vim.api.nvim_win_is_valid(float_win) then
        vim.api.nvim_buf_set_lines(float_buf, 0, -1, false, { text })
        vim.api.nvim_win_set_width(float_win, width)
        return
    end

    float_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(float_buf, 0, -1, false, { text })

    float_win = vim.api.nvim_open_win(float_buf, false, {
        relative = "cursor",
        row = 1,
        col = 1,
        width = width,
        height = 1,
        style = "minimal",
        border = "rounded",
    })

    -- Close on cursor move
    vim.api.nvim_create_autocmd("CursorMoved", {
        group = qf_float_autogroup,
        once = true,
        callback = close_qf_float_window,
    })

    -- Close on mode change
    vim.api.nvim_create_autocmd("ModeChanged", {
        group = qf_float_autogroup,
        once = true,
        callback = close_qf_float_window,
    })

    -- Close on InsertLeave
    vim.api.nvim_create_autocmd("InsertLeave", {
        group = qf_float_autogroup,
        once = true,
        callback = close_qf_float_window,
    })
end

-- Internal function to enable autocmds for float updates
local function enable_qf_float_autocmds()
    -- QuickFixCmdPost fires after :cnext, :cprev, :copen, etc.
    vim.api.nvim_create_autocmd("QuickFixCmdPost", {
        group = qf_float_autogroup,
        pattern = "*",
        callback = update_qf_float,
    })

    -- Also update float on cursor movement if quickfix has items
    vim.api.nvim_create_autocmd("CursorMoved", {
        group = qf_float_autogroup,
        pattern = "*",
        callback = function()
            local qf = vim.fn.getqflist()
            if not vim.tbl_isempty(qf) then
                update_qf_float()
            end
        end,
    })
end

-- Toggle command
vim.api.nvim_create_user_command("ToggleQuickfixFloat", function()
    if qf_enabled then
        -- Disable
        vim.api.nvim_clear_autocmds({ group = qf_float_autogroup })
        close_qf_float_window()
        qf_enabled = false
        print("Quickfix float disabled")
    else
        -- Enable
        enable_qf_float_autocmds()
        qf_enabled = true
        print("Quickfix float enabled")
    end
end, { desc = "Toggle automatic Quickfix float window" })

-- Keymaps to move through quickfix
vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz:lua update_qf_float()<CR>")
vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz:lua update_qf_float()<CR>")

-- Close float on <Esc>
vim.keymap.set({ "n", "i", "v" }, "<Esc>", function()
    vim.schedule(close_qf_float_window)
    return "<Esc>"
end, { expr = true, silent = true })
