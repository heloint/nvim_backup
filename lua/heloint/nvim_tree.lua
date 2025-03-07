-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
require("nvim-tree").setup {
    view = {
        width = 45,
    },
    update_focused_file = {
        enable = true,
        update_root = {
            enable = true,
            ignore_list = {},
        },
        exclude = false,
    },
}
