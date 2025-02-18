-- COLORS
-- ====================================================================
vim.cmd("colorscheme retrobox")

local customColors = {
    Normal = { bg = "#27272a" },
    NormalFloat = { bg = "none" },
    FloatBorder = { bg = "none" },

    DiffDelete = { bg = "#b91c1c" },

    LineNr = { bg = "#212424" },
    SignColumn = { bg = "#212424" },
    WinSeparator = { fg = "#f8fafc", bg = "#334155", },
    StatusLine = {bg = "#475569", fg = "#f9fafb"},
    Visual = { bg = "#314158", ctermfg = nil}
}

for hl, col in pairs(customColors) do
    vim.api.nvim_set_hl(0, hl, col)
end

for i = 0, 15 do
    vim.g["terminal_color_" .. i] = nil
end
