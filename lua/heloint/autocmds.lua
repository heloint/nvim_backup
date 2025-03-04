-- Restore cursor position
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
    pattern = { "*" },
    callback = function()
        vim.api.nvim_exec2('silent! normal! g`"zv', { output = false })
    end,
})

-- -- Remove trailing whitespaces on save.
-- vim.api.nvim_create_autocmd({ "BufWritePre" }, {
--     pattern = { "*" },
--     command = [[%s/\s\+$//e]],
-- })

-- Create parent directories if not exists on save.
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = { "*" },
    callback = function()
        local dir = vim.fn.expand('<afile>:p:h')

        -- This handles URLs using netrw. See ':help netrw-transparent' for details.
        if dir:find('%l+://') == 1 then
            return
        end

        if vim.fn.isdirectory(dir) == 0 then
            vim.fn.mkdir(dir, 'p')
        end
    end
})
