-- NETRW CONFIG
-- ====================================================================
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = 30
vim.g.netrw_altv = 1

-- NVIM TREE
-- ====================================================================
-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local function open_nvim_tree()

  -- open the tree
  require("nvim-tree.api").tree.open(update_root)
end

vim.api.nvim_create_autocmd({"VimEnter"}, {callback = open_nvim_tree })

require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    width = 30,
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
    dotfiles = true,
  },
})
