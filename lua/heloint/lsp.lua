local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({buffer = bufnr})
end)

-- LSP ====================================================================
require("mason").setup({
    ui = {
        border = "single",
    },
})

require("mason-lspconfig").setup({ 
    ensure_installed = { 
        "html",
        "emmet_ls",
        "cssls",
        "intelephense",
        "pyright",
        "tsserver",
    },
    handlers = {
        lsp_zero.default_setup,
        emmet_ls = function()
            require('lspconfig')['emmet_ls'].setup { 
                filetypes = { 
                    "html", "css", "sass", "scss", "less", "eruby", "jsp"
                }
            }
        end,
  },
})

