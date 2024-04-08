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

-- INDENT WITH TAB
-- ===============
vim.keymap.set('i', '<S-Tab>', '<Esc><<i', { silent = true })
vim.keymap.set('x', '<Tab>', '>gv', { silent = true })
vim.keymap.set('x', '<S-Tab>', '<gv', { silent = true })

-- COPY PASTA DON'T OVERWRITE
-- ==========================
vim.keymap.set('x', 'p', 'pgvy', { silent = true })

-- TOGGLE NVIM-TREE
-- ================
vim.keymap.set('i', '<C-b>', '<Esc>:NvimTreeToggle<CR>', { silent = true })
vim.keymap.set('n', '<C-b>', '<Esc>:NvimTreeToggle<CR>', { silent = true })

-- RETURN TO NORMAL MODE IN THE INTEGRATED TERMINAL (UNUSED)
-- =========================================================
vim.keymap.set('t', '<Esc>', '<C-\\><C-N>', { silent = true })

-- TELESCOPE MAPPING
-- =================

function vim.getVisualSelection()
    vim.cmd('noau normal! "vy"')
    local text = vim.fn.getreg('v')
    vim.fn.setreg('v', {})

    text = string.gsub(text, "\n", "")
    if #text > 0 then
        return text
    else
        return ''
    end
end

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-f>f', function()
    builtin.find_files({ hidden = true })
end)
vim.keymap.set('n', '<C-f>g', builtin.live_grep, {})
vim.keymap.set('v', '<C-f>g', function()
    local text = vim.getVisualSelection()
    builtin.live_grep({ default_text = text })
end, {})
vim.keymap.set('n', '<C-f>b', builtin.buffers, {})
vim.keymap.set('n', '<C-f>h', builtin.help_tags, {})
vim.keymap.set('n', '<C-f>r', builtin.lsp_references, {})
vim.keymap.set('n', '<C-f>q', builtin.resume, {})
vim.keymap.set('n', '<C-f>m', builtin.marks, {})

-- BLOCK COMMENTING
-- ================
require('kommentary.config').use_extended_mappings()

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
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
        vim.keymap.set('n', '<space>d', vim.diagnostic.setqflist, opts)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set({ 'v', 'n' }, '<space>ca', vim.lsp.buf.code_action)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<space>f', function()
            require("conform").format({ lsp_fallback=true })
        end, opts)
        vim.keymap.set("v", "<space>f", vim.lsp.buf.format, { remap = false })
    end,
})

-- TOGGLE MY TERMINAL
local my_terminal = require('heloint.my_terminal')
vim.keymap.set('n', '<space>t', my_terminal.toggle_terminal, {})

local my_quickfixlist = require('heloint.my_quickfixlist')
vim.keymap.set('n', '<C-q>', my_quickfixlist.toggle_qf, {})

vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz")

-- DAPS
vim.keymap.set("n", "<F4>", ":lua require('dapui').toggle()<CR>")
vim.keymap.set("n", "<F6>", ":lua require('dap').toggle_breakpoint()<CR>")
vim.keymap.set("n", "<F9>", ":lua require('dap').continue()<CR>")
vim.keymap.set("n", "<F1>", ":lua require('dap').step_over()<CR>")
vim.keymap.set("n", "<F2>", ":lua require('dap').step_into()<CR>")
vim.keymap.set("n", "<F3>", ":lua require('dap').step_out()<CR>")
