-- PLUGINS
-- ====================================================================
return require('packer').startup(function()
    use 'wbthomason/packer.nvim'

    -- TREE OF LIFE
    -- THE GREATEST FZF (NEEDS: RIPGREP & LOVE)
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        requires = { {'nvim-lua/plenary.nvim'} }
    }

    -- AUTOCOMPLETE

    -- OTHER USEFUL JUNKS
    use 'b3nj5m1n/kommentary'

    -- THEME AND STUFF
    use {
      'nvim-lualine/lualine.nvim',
      requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }
    use 'rebelot/kanagawa.nvim'
    use 'nvim-tree/nvim-tree.lua'

    -- MANAGE LSP AND STUFF
    use 'neovim/nvim-lspconfig'

    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/vim-vsnip'
    use 'hrsh7th/vim-vsnip-integ'
    use 'L3MON4D3/LuaSnip'
end)
