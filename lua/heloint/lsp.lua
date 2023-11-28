local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp_zero.default_keymaps({ buffer = bufnr })
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
        "tsserver",
        "jdtls",
        "pylsp",
    },
    handlers = {
        lsp_zero.default_setup,
        emmet_ls = function()
            require('lspconfig')['emmet_ls'].setup {
                filetypes = {
                    "css",
                    "eruby",
                    "html",
                    "javascript",
                    "javascriptreact",
                    "less",
                    "sass",
                    "scss",
                    "svelte",
                    "pug",
                    "typescriptreact",
                    "vue",
                }
            }
        end,
        jdtls = lsp_zero.noop,
        pylsp = function()
            require'lspconfig'.pylsp.setup{
              settings = {
                pylsp = {
                  plugins = {
                    pycodestyle = {
                      ignore = {'W391'},
                      maxLineLength = 100
                    },
                  }
                }
              }
            }
        end,
    },
})
