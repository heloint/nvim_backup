-- NETRW CONFIG
-- ============
--[[ vim.g.netrw_banner = 1
vim.g.netrw_liststyle = 0
vim.g.netrw_winsize = 30 ]]

-- NVIM-TREE CONFIG
-- ============
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- empty setup using defaults
require("nvim-tree").setup()

-- OR setup with some options
require("nvim-tree").setup({
    sort_by = "case_sensitive",
    update_focused_file = {
        enable = true,
    },
    view = {
        width = 30,
    },
    renderer = {
        group_empty = true,
    },
    diagnostics = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = true,
    },
})
