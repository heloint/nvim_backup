-- LSP ====================================================================
require("mason").setup({
    ui = {
        border = "single",
    },
})
require("mason-lspconfig").setup({ 
    ensure_installed = { 
        "html",
        "pylsp",
        "cssls",
        "intelephense",
        "eslint",
        "tsserver",
        "angularls",
        "rust_analyzer",
    } 
})

-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities(
                        vim.lsp.protocol.make_client_capabilities()
)
capabilities.textDocument.completion.completionItem.snippetSupport = true

require('lspconfig')['intelephense'].setup { capabilities = capabilities }
require('lspconfig')['eslint'].setup { capabilities = capabilities }
require('lspconfig')['tsserver'].setup { capabilities = capabilities }
require('lspconfig')['angularls'].setup { capabilities = capabilities }
require('lspconfig')['cssls'].setup { capabilities = capabilities }
require('lspconfig')['emmet_ls'].setup { 
    capabilities = capabilities,
    filetypes = { 
        "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "eruby", "jsp"
    }
}
require('lspconfig')['html'].setup { 
    capabilities = capabilities,
    filetypes = {'jsp', 'html'}
}
require('lspconfig')['gopls'].setup { capabilities = capabilities }
require('lspconfig')['pylsp'].setup { 
    capabilities = capabilities, settings = {
        pylsp = { 
            plugins = { 
                pycodestyle = { 
                    ignore = {'W391'}, 
                    maxLineLength = 100 
                } 
            } 
        } 
    } 
}
