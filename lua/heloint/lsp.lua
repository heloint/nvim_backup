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
        "lua_ls",
    },
    handlers = {
        lsp_zero.default_setup,
        jdtls = lsp_zero.noop,
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
        lua_ls = function()
            require('lspconfig').lua_ls.setup {
                settings = {
                    Lua = {
                        runtime = {
                            -- Tell the language server which version of Lua you're using
                            -- (most likely LuaJIT in the case of Neovim)
                            version = 'LuaJIT',
                        },
                        diagnostics = {
                            -- Get the language server to recognize the `vim` global
                            globals = {
                                'vim',
                                'require'
                            },
                        },
                        workspace = {
                            -- Make the server aware of Neovim runtime files
                            library = vim.api.nvim_get_runtime_file("", true),
                        },
                        -- Do not send telemetry data containing a randomized but unique identifier
                        telemetry = {
                            enable = false,
                        },
                    },
                },
            }
        end
    },
})
