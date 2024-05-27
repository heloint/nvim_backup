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
        },
        buffers = {
        },
        help_tags = {
        }
    },
}
