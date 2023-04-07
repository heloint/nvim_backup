-- COLORS
-- ====================================================================
vim.cmd("colorscheme nightfox")
vim.cmd(":hi MatchParen cterm=bold ctermfg=yellow ctermbg=darkgrey")
vim.cmd('set fillchars=vert:\\┃,fold:\\┄')
vim.cmd('highlight VertSplit guifg=#ff8800 guibg=NONE')
vim.cmd('highlight Visual guibg=#4e5a6d guifg=NONE')
vim.cmd('highlight MatchParen ctermbg=yellow guibg=yellow')

-- INDENT INDENT-BLANKLINE
-- ===============================================================
vim.opt.list = true
vim.opt.listchars:append "space:⋅"

require("indent_blankline").setup {
    space_char_blankline = " ",
    show_current_context = true,
    show_current_context_start = true,
}

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
              path = 2 -- 0 = just filename, 1 = relative path, 2 = absolute path
            }
        }
    }
}

-- SCROLLBAR
-- ====================================================================
require("scrollbar").setup()

