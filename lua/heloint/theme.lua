-- COLORS
-- ====================================================================
vim.cmd("colorscheme kanagawa")

local telescopeColors = {
    Normal = { bg = "#27272a" },
    NormalFloat = { bg = "none" },
    FloatBorder = { bg = "none" },

    TelescopeNormal = { bg = "none" },
    TelescopeResultsBorder = { bg = "none" },
    TelescopePromptBorder = { bg = "none" },
    TelescopePreviewBorder = { bg = "none" },

    DiffDelete = { bg = "#b91c1c" },

    LineNr = { bg = "#212424" },
    SignColumn = { bg = "#212424" },
    WinSeparator = { fg = "#f8fafc", bg = "#334155", },
    StatusLine = {bg = "#475569", fg = "#f9fafb"},
}

for hl, col in pairs(telescopeColors) do
    vim.api.nvim_set_hl(0, hl, col)
end
