local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({buffer = bufnr})
end)

lsp.setup()

-- LSP ====================================================================
require("mason").setup({
    ui = {
        border = "single",
    },
})
require("mason-lspconfig").setup({ 
    ensure_installed = { 
        "html",
        "pyright",
        "cssls",
        "intelephense",
        "eslint",
        "tsserver",
        "angularls",
        "rust_analyzer",
    } 
})

require('lspconfig')['emmet_ls'].setup { 
    filetypes = { 
        "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "eruby", "jsp"
    }
}

require('lspconfig')['html'].setup { 
    filetypes = {'jsp', 'html'}
}
