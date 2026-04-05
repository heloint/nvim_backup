-- Restore cursor position
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
    pattern = { "*" },
    callback = function()
        vim.api.nvim_exec2('silent! normal! g`"zv', { output = false })
    end,
})

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

-- Rename buffer's file
vim.api.nvim_create_user_command("Mv", function(opts)
    local current_path = vim.api.nvim_buf_get_name(0)
    local new_path = vim.trim(opts.args)

    if new_path == "" then
        print("Not moved anything")
        return
    end

    -- Rename the current buffer to the new file path.
    vim.api.nvim_buf_set_name(0, new_path)

    -- Create parent directories if needed
    vim.fn.mkdir(vim.fn.fnamemodify(new_path, ":h"), "p")

    -- Move file path to new
    vim.uv.fs_rename(current_path, new_path)

    print("Moved from: ", current_path, "to: ", new_path)
end, { nargs = "*", complete = "file" })

-- Delete buffer's file
vim.api.nvim_create_user_command("Rm", function()
    local current_path = vim.api.nvim_buf_get_name(0)

    -- Close the current buffer to the new file path.
    vim.api.nvim_buf_delete(0, { force = true }) -- discard unsaved changes

    os.remove(vim.fn.expand("%:p"))

    print("Removed file: ", current_path)

    local buflist = vim.fn.getbufinfo({ buflisted = 1 })

    if #buflist <= 1 then
        vim.cmd("Explore")
    end
end, { nargs = "*", complete = "file" })
