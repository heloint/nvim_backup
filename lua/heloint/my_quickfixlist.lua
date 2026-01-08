-- ============================================================================
-- Quickfix List Configuration
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Basic Quickfix Setup
-- ----------------------------------------------------------------------------

-- Make quickfix window modifiable and set up save keybinding
vim.api.nvim_create_autocmd('BufWinEnter', {
    group = vim.api.nvim_create_augroup('quickfix_list_base_group', { clear = true }),
    desc = 'Allow updating quickfix window',
    pattern = 'quickfix',
    callback = function()
        vim.bo.modifiable = true
        -- Support for :vimgrep and 'grep -rin' formats with column information
        vim.bo.errorformat = '%f|%l col %c| %m,%f|%l col %c-%k| %m,%f|%l| %m'
        vim.keymap.set(
            'n',
            '<C-s>',
            '<Cmd>cgetbuffer|set nomodified|echo "quickfix/location list updated"<CR>',
            { buffer = true, desc = 'Update quickfix/location list with changes made in quickfix window' }
        )
    end,
})

-- Toggle quickfix list on the bottom of the screen
vim.keymap.set('n', '<C-q>', function()
    local qf_exists = false
    for _, win in pairs(vim.fn.getwininfo()) do
        if win["quickfix"] == 1 then
            qf_exists = true
        end
    end

    if qf_exists then
        vim.cmd("cclose")
        return
    end

    if not vim.tbl_isempty(vim.fn.getqflist()) then
        vim.cmd("copen")
        vim.cmd("set modifiable")
    end
end, { desc = 'Toggle quickfix list' })

-- ----------------------------------------------------------------------------
-- Quickfix Float Window
-- ----------------------------------------------------------------------------

local float_win = nil
local float_buf = nil
local qf_float_autogroup = vim.api.nvim_create_augroup("QuickfixFloat", { clear = true })
local qf_enabled = false

-- Helper function to strip leading whitespace
local function lstrip(s)
    return s:match("^%s*(.*)$")
end

-- Get quickfix text at current cursor position
local function get_qf_match_at_cursor()
    local qf = vim.fn.getqflist()
    if vim.tbl_isempty(qf) then
        return nil
    end

    local cur_buf = vim.api.nvim_get_current_buf()
    local cur_line = vim.api.nvim_win_get_cursor(0)[1]

    -- Check if current location is in quickfix list
    local is_loc_in_qf = false
    for _, item in ipairs(qf) do
        if item.bufnr == cur_buf and item.lnum == cur_line then
            is_loc_in_qf = true
            break
        end
    end

    if not is_loc_in_qf then
        return nil
    end

    -- Get the current quickfix item text
    local info = vim.fn.getqflist({ idx = 0 })
    local current_idx = info.idx
    local current_item = qf[current_idx]
    return lstrip(current_item.text)
end

-- Close the floating quickfix window
local function close_qf_float_window()
    if float_win and vim.api.nvim_win_is_valid(float_win) then
        vim.api.nvim_win_close(float_win, true)
    end
    float_win = nil
    float_buf = nil
    vim.api.nvim_clear_autocmds({ group = qf_float_autogroup })
end

-- Get text and calculate appropriate window size
local function get_qf_float_text_and_size()
    local text = get_qf_match_at_cursor()
    if text == nil then return nil, 0, 0 end

    -- Set a maximum width for wrapping
    local max_width = math.min(80, vim.o.columns - 4)

    -- Calculate how many lines we need after wrapping
    local text_len = vim.fn.strdisplaywidth(text)
    local height = math.ceil(text_len / max_width)
    height = math.max(height, 1)
    height = math.min(height, 10) -- Cap at 10 lines

    return text, max_width, height
end

-- Update or create the floating quickfix window
function update_qf_float()
    if not qf_enabled then return end -- <--- add this
    local text, width, height = get_qf_float_text_and_size()
    if text == nil then return end

    local text, width = get_qf_float_text_and_size()
    if text == nil then
        return
    end

    -- Update existing float window
    if float_win and vim.api.nvim_win_is_valid(float_win) then
        vim.api.nvim_buf_set_lines(float_buf, 0, -1, false, { text })
        vim.api.nvim_win_set_width(float_win, width)
        vim.api.nvim_win_set_height(float_win, height)
        vim.api.nvim_set_option_value('wrap', true, { win = float_win })
        return
    end

    -- Create new float window
    float_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(float_buf, 0, -1, false, { text })

    float_win = vim.api.nvim_open_win(float_buf, false, {
        relative = "cursor",
        row = 1,
        col = 1,
        width = width,
        height = height,
        style = "minimal",
        border = "rounded",
    })

    -- Enable text wrapping in the floating window
    vim.api.nvim_set_option_value('wrap', true, { win = float_win })
    vim.api.nvim_set_option_value('linebreak', true, { win = float_win })

    -- Close on cursor move
    vim.api.nvim_create_autocmd("CursorMoved", {
        group = qf_float_autogroup,
        once = true,
        callback = close_qf_float_window,
    })

    -- Auto-close on mode change
    vim.api.nvim_create_autocmd("ModeChanged", {
        group = qf_float_autogroup,
        once = true,
        callback = close_qf_float_window,
    })

    -- Auto-close on insert leave
    vim.api.nvim_create_autocmd("InsertLeave", {
        group = qf_float_autogroup,
        once = true,
        callback = close_qf_float_window,
    })
end

-- Enable autocmds for automatic float updates
local function enable_qf_float_autocmds()
    -- Update float after quickfix commands
    vim.api.nvim_create_autocmd("QuickFixCmdPost", {
        group = qf_float_autogroup,
        pattern = "*",
        callback = update_qf_float,
    })

    -- Update float on cursor movement when quickfix has items
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

-- ----------------------------------------------------------------------------
-- Commands and Keymaps
-- ----------------------------------------------------------------------------

-- Toggle quickfix float functionality
vim.api.nvim_create_user_command("ToggleQuickfixFloat", function()
    if qf_enabled then
        vim.api.nvim_clear_autocmds({ group = qf_float_autogroup })
        close_qf_float_window()
        qf_enabled = false
        print("Quickfix float disabled")
    else
        enable_qf_float_autocmds()
        qf_enabled = true
        print("Quickfix float enabled")
    end
end, { desc = "Toggle automatic Quickfix float window" })

-- Navigate through quickfix list
vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz:lua update_qf_float()<CR>",
    { silent = true, desc = "Next quickfix item" })
vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz:lua update_qf_float()<CR>",
    { silent = true, desc = "Previous quickfix item" })

-- Close float window on escape
vim.keymap.set({ "n", "i", "v" }, "<Esc>", function()
    vim.schedule(close_qf_float_window)
    return "<Esc>"
end, { expr = true, silent = true, desc = "Close quickfix float" })
