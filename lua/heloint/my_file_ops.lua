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


vim.api.nvim_create_user_command("Test", function(opts)
    -- Create session cache directory.
    local cache_base_dir = vim.fn.stdpath('cache')
    local session_base_dir = vim.fs.joinpath(cache_base_dir, "my_session_caches")
    vim.fn.mkdir(session_base_dir, "p")

    -- Create the session cache hash
    local cwd = vim.fn.getcwd()
    local cwd_hash = vim.fn.sha256(cwd)

    -- Create / retrieve session cache
    local session_cache_path = vim.fs.joinpath(session_base_dir, cwd_hash)
    local has_session = vim.uv.fs_stat(session_cache_path)
    if has_session then
        vim.cmd("source " .. session_cache_path)
    else
        vim.cmd("mksession! " .. session_cache_path)
    end

end, { nargs = "*", complete = "file" })
