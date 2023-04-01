-- TELESCOPE SETUP AND KEYBINDS
-- ====================================================================
require('telescope').setup{
  defaults = {
    layout_strategy = 'vertical',
    layout_config = { height = 0.95 },
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
