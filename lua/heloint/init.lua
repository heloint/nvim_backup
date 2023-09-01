local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)


require("lazy").setup({
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function () 
            local configs = require("nvim-treesitter.configs")

            configs.setup({
                ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html" },
                sync_install = false,
                highlight = { enable = true },
                indent = { enable = true },  
                auto_install = true,
            })
        end
    },
    {"rebelot/kanagawa.nvim", lazy=true},
    { "lukas-reineke/indent-blankline.nvim", lazy=true},
    { "nvim-lualine/lualine.nvim", lazy=true},
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.2',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    { 'b3nj5m1n/kommentary', lazy=true},
    { 'windwp/nvim-ts-autotag', lazy=true},
    {'nvim-tree/nvim-tree.lua', lazy=true},
    {"mfussenegger/nvim-jdtls", lazy=true},
    {'mfussenegger/nvim-dap', lazy=true},
    {'rcarriga/nvim-dap-ui', lazy=true},
    { 'leoluz/nvim-dap-go', lazy=true }, 
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        dependencies = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},             -- Required
            {'williamboman/mason.nvim'},           -- Optional
            {'williamboman/mason-lspconfig.nvim'}, -- Optional

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
},
{
    ui = {
        border = "rounded"
    }
}
)

require("heloint.set")
require("heloint.keymaps")
require("heloint.theme")
require("heloint.file_explorer")
require("heloint.cmp")
require("heloint.lsp")
require("heloint.treesitter")
require("heloint.telescope")
require("heloint.autocmds")
require("heloint.daps")

