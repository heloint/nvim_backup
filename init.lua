local g   = vim.g
local o   = vim.o
local opt = vim.opt
local A   = vim.api

-- COLORS
vim.cmd("colorscheme desert")
-- vim.cmd[[hi Pmenu ctermfg=NONE ctermbg=236 cterm=NONE guifg=NONE guibg=#64666d gui=NONE]]
-- vim.cmd[[hi PmenuSel ctermfg=NONE ctermbg=24 cterm=NONE guifg=NONE guibg=#204a87 gui=NONE]]
vim.cmd[[highlight LineNr ctermfg=grey]]
vim.cmd[[hi Visual cterm=none ctermbg=darkgrey ctermfg=cyan]]
vim.cmd(":hi Cursorline cterm=NONE ctermbg=236")
vim.cmd(":highlight ExtraWhitespace ctermbg=196 guibg=red")
vim.cmd(":match ExtraWhitespace /\\s\\+$/ ")

-- DEFAULTS
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

-- KEYBINDINGS / KEY-REMAPS
vim.keymap.set('n', '<F5>', '<Esc>:!python %<CR>', { silent = true})
vim.keymap.set('i', '{<CR>', '{<CR>}<Esc><S-O>', { silent = true})
vim.keymap.set('i', '<S-Tab>', '<Esc><<i', { silent = true})
vim.keymap.set('x', '<Tab>', '>', { silent = true})
vim.keymap.set('x', '<S-Tab>', '<', { silent = true})
vim.keymap.set('x', '"', 'c""<Esc>P', { silent = true})
vim.keymap.set('x', "'", "c''<Esc>P", { silent = true})
vim.keymap.set('x', '(', 'c()<Esc>P', { silent = true})
vim.keymap.set('x', '[', 'c[]<Esc>P', { silent = true})
vim.keymap.set('i', '<C-b>', '<Esc>:Lexplore<CR>', { silent = true})
vim.keymap.set('n', '<C-b>', '<Esc>:Lexplore<CR>', { silent = true})
vim.keymap.set('n', 'H', 'gT', { silent = true})
vim.keymap.set('n', 'L', 'gt', { silent = true})

-- NETRW CONFIG
g.netrw_banner = 0
g.netrw_liststyle = 3
g.netrw_winsize = 30
g.netrw_altv = 1

--[[ -- ====================================================================
-- PLUGIN CONFIGS AND INITS
-- ====================================================================
-- Block commenting
require('kommentary.config').use_extended_mappings()

-- LSP
require'lspconfig'.pyright.setup{}
require'lspconfig'.intelephense.setup{}
require'lspconfig'.eslint.setup{}
require'lspconfig'.tsserver.setup{}
require("scrollbar").setup()
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
      -- ['<Esc>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' },
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
  local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
  require('lspconfig')['pyright'].setup {
    capabilities = capabilities
  }

-- DON'T FORGET AFTER INSTALL :: TSInstall html/php/etc... + TSEnable autotag !!
require('nvim-ts-autotag').setup()
-- ==================================================================== ]]

-- PLUGINS
return require('packer').startup(function()
  -- Packer can manage itself
    use 'wbthomason/packer.nvim'
    use 'neovim/nvim-lspconfig'
    use 'b3nj5m1n/kommentary'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/nvim-cmp'
    use 'petertriho/nvim-scrollbar'
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }

    use 'windwp/nvim-ts-autotag'

end)
