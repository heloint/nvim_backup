local g   = vim.g
local o   = vim.o
local opt = vim.opt
local A   = vim.api

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
o.scrolloff = 10
o.showcmd = true
o.showmatch = true

o.completeopt = 'menu,menuone,noinsert'
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
map('i', '{<CR>', '{<CR>}<Esc><S-O>')
map('i', '<S-Tab>', '<Esc><<i')
map('x', '<Tab>', '>')
map('x', '<S-Tab>', '<')
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

--[[ -- PLUGIN CONFIGS AND INITS
-- ====================================================================
-- TOOOOKYYYOOO - "ThePrimeagen"
g.tokynight_transparent_sidebar = true
g.tokynight_transparent = true
opt.background = "dark"
vim.cmd("colorscheme tokyonight")

-- Lua line, very nice - "Borat"
require('lualine').setup{ options = { theme = 'gruvbox' }}
vim.cmd("set encoding=UTF-8")

-- Block commenting
require('kommentary.config').use_extended_mappings()

-- LSP
require'lspconfig'.pyright.setup{}
require'lspconfig'.intelephense.setup{}
require'lspconfig'.eslint.setup{}
require'lspconfig'.tsserver.setup{}
-- ====================================================================

-- SETUP CMP AUTOCOMPLETE
-- ====================================================================
local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-h>'] = cmp.mapping.scroll_docs(-4),
      ['<C-k>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<Esc>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Setup lspconfig.
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  require('lspconfig')['pyright'].setup {
    capabilities = capabilities
  }

-- DON'T FORGET AFTER INSTALL :: TSInstall html/php/etc... + TSEnable autotag !!
require('nvim-ts-autotag').setup()

-- TELESCOPE FINDER AND IT'S KEY-MAPPING
require('telescope').setup()
-- nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
-- nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
-- nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
-- nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

map('n', '<C-f>f', '<Esc>:Telescope find_files <CR>')
map('n', '<C-f>g', '<Esc>:Telescope live_grep <CR>')
map('n', '<C-f>b', '<Esc>:Telescope buffers <CR>')
map('n', '<C-f>h', '<Esc>:Telescope help_tags <CR>') ]]
-- ====================================================================

-- PLUGINS
return require('packer').startup(function()
  -- Packer can manage itself
    use 'wbthomason/packer.nvim'
    use 'neovim/nvim-lspconfig'
    use "lukas-reineke/indent-blankline.nvim"
    use 'folke/tokyonight.nvim'
    use {
      'nvim-lualine/lualine.nvim',
      requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }
    use 'b3nj5m1n/kommentary'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/nvim-cmp'
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }
    use 'windwp/nvim-ts-autotag'
    use {
      'nvim-telescope/telescope.nvim', tag = '0.1.0',
    -- or                            , branch = '0.1.x',
      requires = { {'nvim-lua/plenary.nvim'} }
    }

end)
