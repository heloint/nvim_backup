local M = {}
local active_buffers = {}
local original_content = {}

function M.enable(buf)
  buf = buf or vim.api.nvim_get_current_buf()

  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local content = table.concat(lines, "\n")
  local result = vim.fn.system("column -s, -t -o'|'", content)

  -- Create a new scratch buffer
  local preview_buf = vim.api.nvim_create_buf(false, true)

  -- Set content
  vim.api.nvim_buf_set_lines(preview_buf, 0, -1, false, vim.split(result, "\n"))

  -- Open in a vertical split (or use "new" for horizontal)
  vim.cmd("tabe")
  vim.api.nvim_win_set_buf(0, preview_buf)

  -- Make it read-only & safe
  vim.bo[preview_buf].modifiable = false
  vim.bo[preview_buf].buftype = "nofile"
  vim.bo[preview_buf].bufhidden = "wipe"
  vim.bo[preview_buf].swapfile = false

  active_buffers[buf] = preview_buf
end

vim.api.nvim_create_user_command("PrettyCsv", function()
  M.enable()
end, {})

