-- KEYBINDINGS / KEY-REMAPS
-- ========================

-- SWITCH BETWEEN TABS
-- ===================
for i = 1, 9 do
    vim.keymap.set('n', '<space>' .. i, '<Esc>:tabn ' .. i .. '<CR>', { silent = true })
end

vim.keymap.set('n', 'H', 'gT', { silent = true })
vim.keymap.set('n', 'L', 'gt', { silent = true })

-- RESIZE WINDOWS
-- ========================
vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>', { silent = true })
vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>', { silent = true })
vim.keymap.set('n', '<C-Up>', ':resize +2<CR>', { silent = true })
vim.keymap.set('n', '<C-Down>', ':resize -2<CR>', { silent = true })

-- RUN CURRENT PYTHON SCRIPT
-- =========================
vim.keymap.set('n', '<F5>', '<Esc>:!python %<CR>', { silent = true })

-- AUTOCLOSE BRACE SCOPE BLOCK
-- ===========================
vim.keymap.set('i', '{<CR>', '{<CR>}<Esc><S-O>', { silent = true })

-- AUTOCLOSE PARENTHESIS SCOPE BLOCK
-- ===========================
vim.keymap.set('i', '(<CR>', '(<CR>)<Esc><S-O>', { silent = true })

-- INDENT WITH TAB
-- ===============
vim.keymap.set('i', '<S-Tab>', '<Esc><<i', { silent = true })
vim.keymap.set('x', '<Tab>', '>gv', { silent = true })
vim.keymap.set('x', '<S-Tab>', '<gv', { silent = true })

-- COPY PASTA DON'T OVERWRITE
-- ==========================
vim.keymap.set('x', 'p', 'pgvy', { silent = true })

-- Select visually the text, then replace it globally in the current buffer.
vim.keymap.set("v", "<space>r", "y:%s/<C-r>0/<C-r>0/gc<left><left><left>", { desc = "Search/replace visual" })

-- Wild file search
vim.keymap.set("n", "<space>fe", ":e **/*<left><right>", {})
vim.keymap.set("n", "<space>ft", ":tabe **/*<left><right>", {})

vim.keymap.set("n", "<C-b>", ":NvimTreeToggle<CR>", {})

--LSP MAPPINGS
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1, float = true }) end)
vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = -1, float = true }) end)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', '<space>h', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<space>d', vim.diagnostic.setloclist, opts)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set({ 'v', 'n' }, '<space>ca', vim.lsp.buf.code_action)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        -- vim.keymap.set('n', '<space>f', vim.lsp.buf.format, opts)
        vim.keymap.set('n', '<space>f', function()
            require("conform").format({ lsp_fallback = true })
        end, opts)
        vim.keymap.set("v", "<space>f", function()
                require("conform").format({ lsp_fallback = true })
            end,
            { remap = false })
    end,
})

