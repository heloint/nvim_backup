local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({buffer = bufnr})
end)

lsp.skip_server_setup({'jdtls'})

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
        "cssls",
        "intelephense",
        "pylsp",
        "pyright",
        "jdtls",
        "tsserver",
    } 
})

require('lspconfig')['emmet_ls'].setup { 
    filetypes = { 
        "html", "css", "sass", "scss", "less", "eruby", "jsp"
    }
}

require('lspconfig')['html'].setup { 
    filetypes = {'jsp', 'html'}
}

require'lspconfig'.pylsp.setup{
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          ignore = {'W391', 'W503'},
          maxLineLength = 100
        }
      }
    }
  }
}
