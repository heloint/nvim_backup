-- NETRW CONFIG
-- ====================================================================
-- vim.g.netrw_banner = 0
-- vim.g.netrw_liststyle = 3
-- vim.g.netrw_winsize = 30
-- vim.g.netrw_altv = 1

-- NVIM TREE
-- ====================================================================
-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
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
    width = {min = 40},
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
})

local function open_nvim_tree()
  -- open the tree
  require("nvim-tree.api").tree.open(update_root)
end

vim.api.nvim_create_autocmd({"VimEnter"}, {callback = open_nvim_tree })
