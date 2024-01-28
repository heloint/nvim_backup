-- TREE SITTER
-- ====================================================================
require 'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all"
    ensure_installed = {
        "vim",
        "typescript",
        "javascript",
        "python",
        "php",
        "bash",
        "c",
        "lua",
        "rust",
        "html",
        "css",
        "query",
    },
    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = true,
    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true,
    highlight = {
        enable = true,
        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },
    autotag = {
        enable = true
    },
}

local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.blade = {
    install_info = {
        url = "https://github.com/EmranMR/tree-sitter-blade",
        files = { "src/parser.c" },
        branch = "main",
    },
    filetype = "blade",
}

vim.treesitter.language.register("html", { "xml", "jsp" })

require('nvim-ts-autotag').setup({
    filetypes = {
        'html', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact',
        'svelte', 'vue', 'tsx', 'jsx', 'rescript', 'xml', 'php', 'markdown',
        'markdown_inline', 'glimmer', 'handlebars', 'hbs', 'jsp', "blade",
    },
})
