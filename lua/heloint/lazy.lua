-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
        {
            "nvim-treesitter/nvim-treesitter",
            build = ":TSUpdate",
        },
        {
            'VonHeikemen/lsp-zero.nvim',
            branch = 'v3.x',
            dependencies = {
                -- LSP Support
                { 'neovim/nvim-lspconfig' },             -- Required
                { 'williamboman/mason.nvim' },           -- Optional
                { 'williamboman/mason-lspconfig.nvim' }, -- Optional

                -- Autocompletion
                { 'neovim/nvim-lspconfig' },
                { 'hrsh7th/cmp-nvim-lsp' },
                { 'hrsh7th/nvim-cmp' },
                { 'hrsh7th/cmp-buffer' },
            }
        },
        { 'numToStr/Comment.nvim' },
        { 'windwp/nvim-ts-autotag', lazy = true },
        {
            "nvim-tree/nvim-tree.lua",
            version = "*",
            lazy = false,
            dependencies = {
                "nvim-tree/nvim-web-devicons",
            },
            config = function()
                -- disable netrw at the very start of your init.lua
                vim.g.loaded_netrw = 1
                vim.g.loaded_netrwPlugin = 1
                require("nvim-tree").setup({
                    view = {
                        width = 45,
                    },
                    update_focused_file = {
                        enable = true,
                        update_root = {
                            enable = true,
                            ignore_list = {},
                        },
                        exclude = false,
                    },
                }
                )
            end,
        },
        {
            "antosha417/nvim-lsp-file-operations",
            dependencies = {
                "nvim-lua/plenary.nvim",
            },
            config = function()
                require("lsp-file-operations").setup()
            end
        },
        {
            'nvim-telescope/telescope.nvim',
            tag = '0.1.8',
            dependencies = { 'nvim-lua/plenary.nvim' }
        },
        { 'nvim-treesitter/nvim-treesitter-context', lazy = true },
        {
            'stevearc/conform.nvim',
            opts = {
                formatters_by_ft = {
                    lua = { "stylua" },
                    -- Conform will run multiple formatters sequentially
                    python = { "isort", "black" },
                    -- Conform will run the first available formatter
                    javascript = { "prettier", stop_after_first = true },
                    typescript = { "prettier", stop_after_first = true },
                    typescriptreact = { "prettier", stop_after_first = true },
                },
            },
        },
    },
    {
        ui = {
            border = "rounded",
        }
    }
)
