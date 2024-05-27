-- DEFAULTS
-- ====================================================================
vim.cmd("set encoding=UTF-8")
vim.opt.relativenumber = true

vim.o.clipboard = 'unnamedplus'
vim.o.number = true
vim.o.mouse= "a"
vim.o.scrolloff = 10
vim.o.sidescrolloff = 30

vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.autoindent = true
vim.o.smartindent  = true

vim.o.backup = false
vim.o.undofile = true
vim.o.swapfile = false
vim.o.undodir = os.getenv("HOME") .. "/.vim/undodir"

vim.o.incsearch = true
vim.o.smartcase = true
vim.o.ignorecase = true

vim.o.wrap = false
vim.o.hidden = true

vim.o.laststatus = 2
vim.o.showcmd = true
vim.o.showmatch = true
vim.o.pumheight = 10
vim.o.cursorline = true
vim.bo.modifiable = true

