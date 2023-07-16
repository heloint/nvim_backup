-- NETRW CONFIG
-- ====================================================================
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = 30
vim.g.netrw_altv = 1
vim.g.netrw_keepdir = 0

-- NVIM TREE
-- ====================================================================
-- disable netrw at the very start of your init.lua (strongly advised)
--[[ vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("nvim-tree").setup({
    hijack_directories = {
        enable = true,
        auto_open = true,
    },
    update_focused_file = {
        enable = true,
        update_cwd = true,
    },
    respect_buf_cwd = true,
    sort_by = "case_sensitive",
    view = {
        mappings = {
            list = {
                { key = "u", action = "dir_up" },
            },
        },
    },
    renderer = {
        group_empty = true,
    },
    filters = {
        dotfiles = false,
    },
    diagnostics = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = true,
    },
})

local function open_nvim_tree()
    -- open the tree
    -- print(vim.fn.isdirectory(vim.api.nvim_buf_get_name(0)))
    if vim.fn.isdirectory(vim.api.nvim_buf_get_name(0)) == 1 then
        require("nvim-tree.api").tree.open(update_root)
    end
end
-- open_nvim_tree()

vim.api.nvim_create_autocmd({"VimEnter"}, {callback = open_nvim_tree }) ]]
