-- COLORS
-- ====================================================================
vim.cmd("colorscheme kanagawa-wave")

require('kanagawa').setup({
    dimInactive = true,
})

-- INDENT INDENT-BLANKLINE
-- ===============================================================
vim.opt.list = true
vim.opt.listchars:append "space:⋅"
require("ibl").setup()
