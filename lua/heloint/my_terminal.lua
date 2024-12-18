function Open_terminal_horizontal()
    vim.cmd('botright split')
    vim.cmd('terminal')
    vim.cmd('resize 20')
end

-- Define a function to jump to the first terminal window in the current tab
function Toggle_terminal()
    local window_had_terminal = false
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local bufnr = vim.api.nvim_win_get_buf(win)
        local bufname = vim.fn.bufname(bufnr)
        if string.sub(bufname, 1, 7) == 'term://' then
            vim.api.nvim_set_current_win(win)
            vim.api.nvim_buf_delete(bufnr, { force = true })
            window_had_terminal = true
            break
        end
    end
    if not window_had_terminal then
        Open_terminal_horizontal()
    end
end

-- Toggle terminal on the bottom of the screen.
vim.keymap.set('n', '<space>t', Toggle_terminal, {})

-- Return to normal mode in the integrated terminal
-- =========================================================
vim.keymap.set('t', '<Esc>', '<C-\\><C-N>', { silent = true })
