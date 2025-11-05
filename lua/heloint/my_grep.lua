local does_uses_ripgrep = vim.o.grepprg:find("^rg ") ~= nil
local does_unrestricted = vim.o.grepprg:match("%-u+ ") ~= nil

if does_uses_ripgrep and does_unrestricted then
    local without_unrestricted = vim.o.grepprg:gsub("%-u+%s*", "")
    vim.o.grepprg = without_unrestricted
end

vim.keymap.set("v", "<space>gt", "y:tabe | silent grep \"<C-r>0\"<left>", { desc = "Grep selected text in new tab." })
vim.keymap.set("v", "<space>gv", "y:vs | silent grep \"<C-r>0\"<left>",
    { desc = "Grep selected text in new vertical split." })
vim.keymap.set("v", "<space>gs", "y:sp | silent grep \"<C-r>0\"<left>",
    { desc = "Grep selected text in new horizontal split." })
vim.keymap.set("v", "<space>gg", "y:silent grep \"<C-r>0\"<left>", { desc = "Grep selected text in current window." })
