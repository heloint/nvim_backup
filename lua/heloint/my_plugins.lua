vim.pack.add({
    -- Same as above, but using a table (allows setting other options)
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter',        name = 'tree-sitter' },
    { src = 'https://github.com/neovim/nvim-lspconfig',                  name = 'nvim-lspconfig' },
    { src = "https://github.com/mason-org/mason.nvim" },
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = 'https://github.com/hrsh7th/cmp-nvim-lsp' },
    { src = 'https://github.com/hrsh7th/nvim-cmp' },
    { src = 'https://github.com/hrsh7th/cmp-buffer' },
    { src = "https://github.com/mason-org/mason-lspconfig.nvim" },

    { src = 'https://github.com/windwp/nvim-ts-autotag' },

    { src = 'https://github.com/nvim-treesitter/nvim-treesitter-context' },

    { src = 'https://github.com/stevearc/conform.nvim' },

    -- -- Specify plugin's name (here the plugin will be called "plugin2"
    -- -- instead of "generic-name")
    -- { src = 'https://github.com/user/generic-name',   name = 'plugin2' },
    --
    -- -- Specify version to follow during install and update
    -- {
    --     src = 'https://github.com/user/plugin3',
    --     -- Version constraint, see |vim.version.range()|
    --     version = vim.version.range('1.0'),
    -- },
    -- {
    --     src = 'https://github.com/user/plugin4',
    --     -- Git branch, tag, or commit hash
    --     version = 'main',
    -- },
})
