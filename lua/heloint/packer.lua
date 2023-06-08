-- PLUGINS
-- ====================================================================
return require('packer').startup(function()
    use 'wbthomason/packer.nvim'

    -- TREE OF LIFE
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }

    -- THE GREATEST FZF (NEEDS: RIPGREP & LOVE)
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        requires = { {'nvim-lua/plenary.nvim'} }
    }

    -- FILE EXPLORER
    use {
      'nvim-tree/nvim-tree.lua',
      requires = {
        'nvim-tree/nvim-web-devicons',
      },
      tag = 'nightly'
    }

    -- AUTOCOMPLETE

    -- OTHER USEFUL JUNKS
    use 'b3nj5m1n/kommentary'
    use 'windwp/nvim-ts-autotag'

    -- THEME AND STUFF
    use "lukas-reineke/indent-blankline.nvim"
    use {
      'nvim-lualine/lualine.nvim',
      requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }
    use 'rebelot/kanagawa.nvim'

    -- FOR JAVA (WHICH SUCKS BTW)
    use "mfussenegger/nvim-jdtls"
    use 'mfussenegger/nvim-dap'
    use 'rcarriga/nvim-dap-ui'

    -- MANAGE LSP AND STUFF
    use {
      'VonHeikemen/lsp-zero.nvim',
      branch = 'v2.x',
      requires = {
        -- LSP Support
        {'neovim/nvim-lspconfig'},
        -- Some Mason job
        {
          'williamboman/mason.nvim',
          run = function()
            pcall(vim.cmd, 'MasonUpdate')
          end,
        },
        {'williamboman/mason-lspconfig.nvim'},

        -- Autocompletion
        {'hrsh7th/nvim-cmp'},
        {'hrsh7th/cmp-nvim-lsp'},
        {'hrsh7th/cmp-buffer'},
        {'hrsh7th/cmp-path'},
        {'hrsh7th/cmp-cmdline'},
        {'hrsh7th/vim-vsnip'},
        {'hrsh7th/vim-vsnip-integ'},
        {'L3MON4D3/LuaSnip'},
      }
    }
end)
