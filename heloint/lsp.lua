-- LSP
-- ====================================================================
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = { "pyright",
                         "cssls",
                         "intelephense",
                         "eslint",
                         "tsserver",
                         "angularls",
                         "rust_analyzer",
                     }
})



  -- Setup lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
  require('lspconfig')['pyright'].setup {
    capabilities = capabilities
  }
  require('lspconfig')['intelephense'].setup {
    capabilities = capabilities
  }
  require('lspconfig')['eslint'].setup {
    capabilities = capabilities
  }
  require('lspconfig')['tsserver'].setup {
    capabilities = capabilities
  }
  require('lspconfig')['angularls'].setup {
    capabilities = capabilities
  }
  require('lspconfig')['cssls'].setup {
    capabilities = capabilities
  }
  require('lspconfig')['gopls'].setup {
    capabilities = capabilities
  }
