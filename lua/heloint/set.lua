local g   = vim.g
local o   = vim.o
local opt = vim.opt
local A   = vim.api

-- DEFAULTS
-- ====================================================================
vim.cmd("set encoding=UTF-8")
opt.relativenumber = true
o.clipboard = 'unnamedplus'
o.number = true
o.mouse= "a"
o.tabstop = 4
o.shiftwidth = 4
o.expandtab = true
o.swapfile = false
o.backup = false
o.smartindent  = true
o.autoindent = true
o.incsearch = true
o.ignorecase = true
o.smartcase = true
o.wrap = false
o.hidden = true
o.laststatus = 2
o.showcmd = true
o.showmatch = true
o.completeopt = 'menu,menuone,noinsert'
o.pumheight = 5
o.cursorline = true
