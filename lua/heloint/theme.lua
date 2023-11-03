-- COLORS
-- ====================================================================
vim.cmd("colorscheme kanagawa-wave")

require('kanagawa').setup({
    dimInactive = true,
})


-- INDENT INDENT-BLANKLINE
-- ===============================================================
vim.opt.list = true
vim.opt.listchars:append "space:⋅"

require("ibl").setup()

-- LUALINE
-- ====================================================================
require('lualine').setup {
    options = {
        theme = 'dracula'
    },
    sections = {
        lualine_a = {
            {
              'filename',
              file_status = true, -- displays file status (readonly status, modified status)
              path = 3 -- 0 = just filename, 1 = relative path, 2 = absolute path
            }
        }
    }
}


