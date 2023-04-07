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

    -- MANAGE LSP AND STUFF
    use {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'neovim/nvim-lspconfig',
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
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/vim-vsnip'
    use 'hrsh7th/vim-vsnip-integ'


    -- OTHER USEFUL JUNKS
    use 'b3nj5m1n/kommentary'
    use 'windwp/nvim-ts-autotag'

    -- THEME AND STUFF
    use 'petertriho/nvim-scrollbar'
    use "EdenEast/nightfox.nvim"
    use "lukas-reineke/indent-blankline.nvim"
    use {
      'nvim-lualine/lualine.nvim',
      requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }
end)
