-- Function to handle opening the quickfix list and horizontal split
local function open_grep_results()
  -- Open the quickfix list
  vim.cmd("copen")
  -- If there are matches, open the first result in a horizontal split
  if not vim.tbl_isempty(vim.fn.getqflist()) then
    vim.cmd("split")   -- Open the result in a horizontal split
  end
end

-- Autocommand to trigger on grep completion
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  pattern = "grep", -- Trigger only for grep commands
  callback = open_grep_results,
})
