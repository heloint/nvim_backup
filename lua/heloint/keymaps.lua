-- KEYBINDINGS / KEY-REMAPS
-- ====================================================================
vim.keymap.set('n', '<F5>', '<Esc>:!python %<CR>', { silent = true})
vim.keymap.set('i', '{<CR>', '{<CR>}<Esc><S-O>', { silent = true})
vim.keymap.set('i', '<S-Tab>', '<Esc><<i', { silent = true})
vim.keymap.set('x', '<Tab>', '>', { silent = true})
vim.keymap.set('x', '<S-Tab>', '<', { silent = true})
vim.keymap.set('x', '"', 'c""<Esc>P', { silent = true})
vim.keymap.set('x', "'", "c''<Esc>P", { silent = true})
vim.keymap.set('x', '(', 'c()<Esc>P', { silent = true})
vim.keymap.set('x', '[', 'c[]<Esc>P', { silent = true})
vim.keymap.set('i', '<C-b>', '<Esc>:NvimTreeToggle<CR>', { silent = true})
vim.keymap.set('n', '<C-b>', '<Esc>:NvimTreeToggle<CR>', { silent = true})
vim.keymap.set('n', 'H', 'gT', { silent = true})
vim.keymap.set('n', 'L', 'gt', { silent = true})


-- Jump to definition shortcut. Using C-Left click can be cumbersome
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
-- Open up a list of references in a quickfix window.
vim.keymap.set('n', 'gf', '<Esc>:lua vim.lsp.buf.references()<CR>', { silent = true})
-- Show info on hover and ctrl-space.
vim.keymap.set('n', '<C-Space>', '<Esc>:lua vim.lsp.buf.hover()<CR>', { silent = true})


local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-f>f', builtin.find_files, {})
vim.keymap.set('n', '<C-f>g', builtin.live_grep, {})
vim.keymap.set('n', '<C-f>b', builtin.buffers, {})
vim.keymap.set('n', '<C-f>h', builtin.help_tags, {})
vim.keymap.set('n', '<C-f>q', builtin.resume, {})

-- Block commenting
-- ====================================================================
require('kommentary.config').use_extended_mappings()
