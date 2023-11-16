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
        "pylsp",
        "tsserver",
        "jdtls",
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
        pylsp = function()
            require('lspconfig')['pylsp'].setup {
                settings = {
                    pylsp = {
                        plugins = {
                            pycodestyle = {
                                ignore = { 'W391', 'W503' },
                                maxLineLength = 100
                            },
                            black = { enabled = true },
                            pylsp_mypy = { enabled = true },
                        }
                    }
                },
                flags = {
                    debounce_text_changes = 200,
                },
                capabilities = capabilities,
            }
            local output_pylsp_mypy = vim.fn.system { 'bash', '-c', 'if [ -z $(pip freeze | grep pylsp-mypy) ]; then pip install pylsp-mypy; fi' }
            local output_pylsp_black = vim.fn.system { 'bash', '-c', 'if [ -z $(pip freeze | grep python-lsp-black) ]; then pip install python-lsp-black; fi' }
        end,
        jdtls = lsp_zero.noop,
    },
})
