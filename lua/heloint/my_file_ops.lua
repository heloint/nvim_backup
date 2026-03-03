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
