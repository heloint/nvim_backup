-- KEYBINDINGS / KEY-REMAPS
-- ========================

-- RESIZE WINDOWS
-- ========================
vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>', {silent = true})
vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>', {silent = true})
vim.keymap.set('n', '<C-Up>', ':resize +2<CR>', {silent = true})
vim.keymap.set('n', '<C-Down>', ':resize -2<CR>', {silent = true})

-- SWITCH BETWEEN TABS
-- ===================
for i = 1, 9 do
  vim.keymap.set('n', '<space>' .. i, '<Esc>:tabn ' .. i .. '<CR>', { silent = true })
end

vim.keymap.set('n', 'H', 'gT', { silent = true})
vim.keymap.set('n', 'L', 'gt', { silent = true})

-- RUN CURRENT PYTHON SCRIPT
-- =========================
vim.keymap.set('n', '<F5>', '<Esc>:!python %<CR>', { silent = true})

-- AUTOCLOSE BRACE SCOPE BLOCK
-- ===========================
vim.keymap.set('i', '{<CR>', '{<CR>}<Esc><S-O>', { silent = true})

-- INDENT WITH TAB
-- ===============
vim.keymap.set('i', '<S-Tab>', '<Esc><<i', { silent = true})
vim.keymap.set('x', '<Tab>', '>gv', { silent = true})
vim.keymap.set('x', '<S-Tab>', '<gv', { silent = true})

vim.keymap.set('x', '"', 'c""<Esc>P', { silent = true})
vim.keymap.set('x', "'", "c''<Esc>P", { silent = true})
vim.keymap.set('x', '(', 'c()<Esc>P', { silent = true})
vim.keymap.set('x', '[', 'c[]<Esc>P', { silent = true})
vim.keymap.set('i', '<C-b>', '<Esc>:NvimTreeToggle<CR>', { silent = true})
vim.keymap.set('n', '<C-b>', '<Esc>:NvimTreeToggle<CR>', { silent = true})

-- RETURN TO NORMAL MODE IN THE INTEGRATED TERMINAL
-- ================================================
vim.keymap.set('t', '<Esc>', '<C-\\><C-N>', { silent = true})


-- TELESCOPE MAPPING
-- =================
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-f>f', builtin.find_files, {})
vim.keymap.set('n', '<C-f>g', builtin.live_grep, {})
vim.keymap.set('n', '<C-f>b', builtin.buffers, {})
vim.keymap.set('n', '<C-f>h', builtin.help_tags, {})
vim.keymap.set('n', '<C-f>r', builtin.lsp_references, {})
vim.keymap.set('n', '<C-f>q', builtin.resume, {})

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
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

-- TOGGLE MY TERMINAL
local my_terminal = require('heloint.my_terminal')
vim.keymap.set('n', '<space>t', my_terminal.toggle_terminal,{})
