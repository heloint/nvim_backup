-- TELESCOPE SETUP AND KEYBINDS
-- ====================================================================

local actions = require('telescope.actions')

require('telescope').setup{
  defaults = {
    file_ignore_patterns = {".git/", ".cache", "%.o", "%.a", "%.out", "%.class",
            "%.pdf", "%.mkv", "%.mp4", "%.zip", "^node_modules/"},
    layout_strategy = 'vertical',
    layout_config = { height = 0.99 },
    mappings = {
        i = {
           ['<C-q>'] = actions.smart_send_to_qflist + actions.open_qflist,
        },
    },
  },
  pickers = {
    find_files = {
    },
    live_grep = {
    },
    buffers = {
    },
    help_tags= {
    }
  },
  extensions = {
  }
}
