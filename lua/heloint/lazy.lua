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
        -- { "rebelot/kanagawa.nvim" },
        {
            "rebelot/kanagawa.nvim",
            lazy = false,
            config = function()
                require("kanagawa").setup({
                    compile = true,
                    functionStyle = { bold = true },
                    dimInactive = true,
                    transparent = true,
                })
                vim.cmd("colorscheme kanagawa-dragon")
            end,
            override = function(colors)
                local theme = colors.theme
                return {
                    NormalFloat = { bg = "none" },
                    FloatBorder = { bg = "none" },
                    FloatTitle = { bg = "none" },
                    NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
                    LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
                    MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
                    Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
                    PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
                    PmenuSbar = { bg = theme.ui.bg_m1 },
                    PmenuThumb = { bg = theme.ui.bg_p2 },
                }
            end,
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
                { 'hrsh7th/nvim-cmp' },
                { 'hrsh7th/cmp-nvim-lsp' },
                { 'hrsh7th/cmp-buffer' },
                { 'hrsh7th/cmp-path' },
                { 'hrsh7th/cmp-cmdline' },
                { 'hrsh7th/vim-vsnip' },
                { 'hrsh7th/vim-vsnip-integ' },
                { 'L3MON4D3/LuaSnip' },
            }
        },
        { "lukas-reineke/indent-blankline.nvim",     main = "ibl", opts = {} },
        {
            'nvim-telescope/telescope.nvim',
            tag = '0.1.4',
            dependencies = { 'nvim-lua/plenary.nvim' }
        },
        { 'numToStr/Comment.nvim',                   lazy = false },
        { 'windwp/nvim-ts-autotag',                  lazy = true },
        { 'nvim-tree/nvim-tree.lua',                 lazy = true },
        { 'nvim-treesitter/nvim-treesitter-context', lazy = true },
        {
            'stevearc/conform.nvim',
            opts = {},
        },
    },
    {
        ui = {
            border = "rounded",
        }
    }
)
