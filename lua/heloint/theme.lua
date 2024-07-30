-- COLORS
-- ====================================================================
vim.cmd("colorscheme habamax")

-- INDENT INDENT-BLANKLINE
-- ===============================================================
vim.opt.list = true
require("ibl").setup()
vim.cmd(":highlight LineNr ctermfg=white")
vim.cmd(":hi Visual cterm=none ctermbg=darkgrey ctermfg=cyan")
