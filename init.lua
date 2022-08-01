local g   = vim.g
local o   = vim.o
local opt = vim.opt
local A   = vim.api

o.clipboard = "unnamedplus"
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
o.scrolloff = 10
o.showcmd = true
o.showmatch = true

o.completeopt = 'longest,menuone,noinsert'
o.pumheight = 5
o.cursorline = true
vim.cmd(":hi Cursorline cterm=NONE ctermbg=236")

-- KEYBINDINGS
vim.cmd [[packadd packer.nvim]]
local function map(m, k, v)
    vim.keymap.set(m, k, v, { silent = true })
end


-- KEY-REMAPS
map('n', '<F5>', '<Esc>:!python %<CR>')

map('i', '<C-d>', '<Bs>')
map('i', '<C-h>', '<Left>')
map('i', '<C-j>', '<Down>')
map('i', '<C-k>', '<Up>')
map('i', '<C-l>', '<Right>')
map('c', '<C-h>', '<Left>')
map('c', '<C-j>', '<Down>')
map('c', '<C-k>', '<Up>')
map('c', '<C-l>', '<Right>')

map('i', '<S-Tab>', '<Esc><<i')
map('x', '"', 'c""<Esc>P')
map('x', "'", "c''<Esc>P")
map('x', '(', 'c()<Esc>P')
map('x', '{', 'c{}<Esc>P')
map('x', '[', 'c[]<Esc>P')
map('x', '*', 'c**<Esc>P')



map('i', '<C-b>', '<Esc>:Lexplore<CR>')
map('n', '<C-b>', '<Esc>:Lexplore<CR>')

-- NETRW CONFIG
g.netrw_banner = 0
g.netrw_liststyle = 3
g.netrw_winsize = 30
g.netrw_altv = 1


-- PLUGIN CONFIGS AND INITS

opt.background = "dark"
vim.cmd("colorscheme tokyonight")

require('lualine').setup()
vim.cmd("set encoding=UTF-8")

require('kommentary.config').use_extended_mappings()

-- PLUGINS
return require('packer').startup(function()
  -- Packer can manage itself
    use 'wbthomason/packer.nvim'
    use 'dense-analysis/ale'
    use "lukas-reineke/indent-blankline.nvim"
    use 'folke/tokyonight.nvim'
    use {
      'nvim-lualine/lualine.nvim',
      requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }
    use 'b3nj5m1n/kommentary'

end)

