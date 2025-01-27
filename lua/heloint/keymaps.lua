-- KEYBINDINGS / KEY-REMAPS
-- ========================

-- SWITCH BETWEEN TABS
-- ===================
for i = 1, 9 do
    vim.keymap.set('n', '<space>' .. i, '<Esc>:tabn ' .. i .. '<CR>', { silent = true })
end

vim.keymap.set('n', 'H', 'gT', { silent = true })
vim.keymap.set('n', 'L', 'gt', { silent = true })

-- RESIZE WINDOWS
-- ========================
vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>', { silent = true })
vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>', { silent = true })
vim.keymap.set('n', '<C-Up>', ':resize +2<CR>', { silent = true })
vim.keymap.set('n', '<C-Down>', ':resize -2<CR>', { silent = true })

-- RUN CURRENT PYTHON SCRIPT
-- =========================
vim.keymap.set('n', '<F5>', '<Esc>:!python %<CR>', { silent = true })

-- AUTOCLOSE BRACE SCOPE BLOCK
-- ===========================
vim.keymap.set('i', '{<CR>', '{<CR>}<Esc><S-O>', { silent = true })

-- AUTOCLOSE PARENTHESIS SCOPE BLOCK
-- ===========================
vim.keymap.set('i', '(<CR>', '(<CR>)<Esc><S-O>', { silent = true })

-- INDENT WITH TAB
-- ===============
vim.keymap.set('i', '<S-Tab>', '<Esc><<i', { silent = true })
vim.keymap.set('x', '<Tab>', '>gv', { silent = true })
vim.keymap.set('x', '<S-Tab>', '<gv', { silent = true })

-- COPY PASTA DON'T OVERWRITE
-- ==========================
vim.keymap.set('x', 'p', 'pgvy', { silent = true })

-- Select visually the text, then replace it globally in the current buffer.
vim.keymap.set("v", "<space>r", "y:%s/<C-r>0//gc<left><left><left>", { desc = "Search/replace visual" })

-- Wild file search
vim.keymap.set("n", "E", ":e **/*<left><right>", {})
vim.keymap.set("n", "T", ":tabe **/*<left><right>", {})
vim.keymap.set("n", "V", ":vs **/*<left><right>", {})
