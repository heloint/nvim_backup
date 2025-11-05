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

-- Loop through easier the quickfix list, without jumping back n' forth the main screen and the QF list.
vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz")
