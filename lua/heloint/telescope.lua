-- TELESCOPE SETUP AND KEYBINDS
-- ====================================================================

local actions = require('telescope.actions')

require('telescope').setup{
  defaults = {
    layout_strategy = 'vertical',
    layout_config = { height = 0.95 },
    mappings = {
        i = {
           ['<C-q>'] = actions.smart_add_to_qflist + actions.open_qflist,
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
    -- ...
  }
}
