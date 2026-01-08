local function get_visual_selection()
    vim.fn.setreg('v', '')
    vim.cmd('normal! "vy')
    return vim.fn.getreg("v")
end

local function get_token_to_log()
    local token = get_visual_selection()
    if token == "" then
        token = vim.fn.expand("<cword>")
    end
    return token
end

local function get_log_function_template()
    local log_functions_by_filetype = {
        python = "print('==> custom-log:', '%s', %s)",
        lua = "print('==> custom-log:', '%s', %s)",
        javascript = "console.log('==> my-loggy:', '%s', %s)",
        typescript = "console.log('==> my-loggy:', '%s', %s)",
    }
    return log_functions_by_filetype[vim.bo.filetype]
end

local function go_normal_mode()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), 'n', true)
end

local function log_it()
    local token = get_token_to_log()
    local log_function_template = get_log_function_template()

    go_normal_mode()

    local buf = vim.api.nvim_get_current_buf()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local linenum = cursor[1] -- 1-based
    local filepath = vim.fn.expand("%")

    local indent = string.rep(" ", vim.fn.indent(linenum))

    local location = string.format("%s:%d:%s=", filepath, linenum, token)
    local log_statement = indent .. string.format(log_function_template, location, token)

    -- Create a blank line below and move cursor to the new line
    vim.api.nvim_buf_set_lines(buf, linenum, linenum, false, { "" })
    vim.api.nvim_win_set_cursor(0, { linenum + 1, 0 })

    vim.api.nvim_set_current_line(log_statement)
end

vim.keymap.set("v", "<space>l", log_it, { desc = "Insert log statement below from selected text." })
vim.keymap.set("n", "<space>l", log_it, { desc = "Insert log statement below from token under the cursor." })

