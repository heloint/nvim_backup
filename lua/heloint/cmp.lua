-- SETUP CMP AUTOCOMPLETE
-- ====================================================================
local cmp = require 'cmp'

cmp.setup({
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-k>'] = cmp.mapping.scroll_docs(-4),
        ['<C-j>'] = cmp.mapping.scroll_docs(4),
        ['<CR>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true, }),

    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
    }, {
        { name = 'buffer' },
    })
})

