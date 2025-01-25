vim.api.nvim_create_user_command("Rename", function(args)
    local current_file_path = vim.fn.expand("%:p")
    local new_file_path = vim.fn.input("Renaming to: ", current_file_path);
    new_file_path = new_file_path:match("^%s*(.-)%s*$")

    -- Print the edited file path
    if new_file_path == '' then
      print('Rename canceled')
      return
    end

    assert(os.rename(current_file_path, new_file_path))
    vim.cmd("bd!|e " .. new_file_path)
    print('Renamed to: ' .. new_file_path)
end
, {desc = "Rename current file"})
