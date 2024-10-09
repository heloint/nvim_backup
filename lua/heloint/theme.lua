-- COLORS
-- ====================================================================
vim.cmd("colorscheme habamax")

local telescopeColors = {
    Normal = { bg = "#27272a" },
    NormalFloat = { bg = "none" },
    FloatBorder = { bg = "none" },
    Visual = { bg = "#9ca3af", fg = "#111827", bold = true },
    TelescopeMatching = { fg = "#b91c1c", bold = true },
    TelescopeSelection = { fg = "#111827", bg = "#9ca3af" },
    DiffDelete = { bg = "#b91c1c" },
}

for hl, col in pairs(telescopeColors) do
    vim.api.nvim_set_hl(0, hl, col)
end
