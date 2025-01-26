local current_term_bufname = nil

function Toggle_terminal()
    -- If we don't have a toggleable terminal initialized, then we init one and return.
    if current_term_bufname == nil or vim.fn.bufexists(current_term_bufname) == 0 then
        vim.cmd.vnew()
        vim.cmd.term()
        local current_buffer = vim.api.nvim_get_current_buf()
        current_term_bufname = vim.fn.bufname(current_buffer)
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
    vim.cmd('vs | b ' .. current_term_bufname)
end
vim.keymap.set('n', '<space>t', Toggle_terminal, {})

-- Return to normal mode in the integrated terminal
-- =========================================================
vim.keymap.set('t', '<Esc>', '<C-\\><C-N>', { silent = true })
