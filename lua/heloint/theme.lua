-- COLORS
-- ====================================================================
vim.cmd("colorscheme default")

local customColors = {
    Normal = { bg = "#27272a" },
    ActiveWindow = { bg = "#27272a" },
    InactiveWindow = { bg = "#16161D" },
    NormalFloat = { bg = "none" },
    FloatBorder = { bg = "none" },

    DiffDelete = { bg = "#b91c1c" },

    LineNr = { bg = "#212424" },
    SignColumn = { bg = "#212424" },
    WinSeparator = { fg = "#f8fafc", bg = "#334155", },
    StatusLine = { bg = "#475569", fg = "#f9fafb" },
    Visual = { bg = "#314158", ctermfg = nil }
}

for hl, col in pairs(customColors) do
    vim.api.nvim_set_hl(0, hl, col)
end

for i = 0, 15 do
    vim.g["terminal_color_" .. i] = nil
end

-- Function to update window highlights
local function set_window_highlight()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        if win == vim.api.nvim_get_current_win() then
            vim.wo[win].winhighlight = "Normal:ActiveWindow,NormalNC:InactiveWindow"
        else
            vim.wo[win].winhighlight = "Normal:InactiveWindow,NormalNC:InactiveWindow"
        end
    end
end

-- Autocommands to update highlights when switching windows or buffers
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
    callback = set_window_highlight,
})
vim.api.nvim_create_autocmd("WinLeave", {
    callback = set_window_highlight,
})
