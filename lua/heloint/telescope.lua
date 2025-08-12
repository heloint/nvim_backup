local telescope = require('telescope')
local actions = require('telescope.actions')

telescope.setup {
    defaults = {
        file_ignore_patterns = { ".git/", "%.o", "%.out", "%.class",
            "%.pdf", "%.mkv", "%.mp4", "%.zip", "^node_modules/" },
        mappings = {
            i = {
                ['<C-q>'] = actions.smart_send_to_qflist + actions.open_qflist,
            },
        },
    },
    pickers = {
        find_files = {
            previewer = false,
        },
        live_grep = {
            layout_strategy = 'vertical',
        },
        buffers = {
            layout_strategy = 'vertical',
        },
        help_tags = {
            layout_strategy = 'vertical',
        }
    },
}

-- TELESCOPE MAPPING
-- =================
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-f>f', function()
    builtin.find_files({ hidden = true })
end)
vim.keymap.set('v', '<C-f>f', function()
    -- When opens up first tries to look for selected text to search for.
    -- If not found, then uses emtpy string as search target.
    vim.cmd('noau normal! "vy"')
    local text = vim.fn.getreg('v')
    vim.fn.setreg('v', {})

    text = string.gsub(text, "\n", "")
    if #text < 1 then
        text = ""
    end

    builtin.find_files({ hidden = true, default_text=text })
end)

vim.keymap.set('n', '<C-f>g', builtin.live_grep, {})
vim.keymap.set('v', '<C-f>g', function()
    -- When opens up first tries to look for selected text to search for.
    -- If not found, then uses emtpy string as search target.
    local conf = require('telescope.config').values
    vim.cmd('noau normal! "vy"')
    local text = vim.fn.getreg('v')
    vim.fn.setreg('v', {})

    text = string.gsub(text, "\n", "")
    if #text < 1 then
        text = ""
    end

    builtin.live_grep({ default_text = text, vimgrep_arguments = table.insert(conf.vimgrep_arguments, '--fixed-strings'), })
end, {})

vim.keymap.set('n', '<C-f>b', builtin.buffers, {})
vim.keymap.set('n', '<C-f>h', builtin.help_tags, {})
vim.keymap.set('n', '<C-f>r', builtin.lsp_references, {})
vim.keymap.set('n', '<C-f>q', builtin.resume, {})
vim.keymap.set('n', '<C-f>m', builtin.marks, {})
vim.keymap.set('n', '<C-f>l', builtin.quickfix, {})
