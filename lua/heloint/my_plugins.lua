vim.pack.add({
    { src = 'https://github.com/neovim/nvim-lspconfig' },
    { src = "https://github.com/mason-org/mason.nvim" },
    { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
    { src = 'https://github.com/stevearc/conform.nvim' },
})

vim.cmd("packadd nvim.undotree")
