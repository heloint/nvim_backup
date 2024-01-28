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
        "pyright",
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
                    "php",
                    "blade.php",
                }
            }
        end,
        intelephense = function()
            require('lspconfig')['intelephense'].setup {
                filetypes = { "php", "blade" },
                settings = {
                    intelephense = {
                        filetypes = { "php", "blade" },
                        files = {
                            associations = { "*.php", "*.blade.php" }, -- Associating .blade.php files as well
                            maxSize = 5000000,
                        },
                    },
                },
            }
        end,
        jdtls = lsp_zero.noop,
    },
})
