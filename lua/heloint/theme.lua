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

-- Current search match (while typing)
vim.api.nvim_set_hl(0, "IncSearch", { bg = "#f7b24a", fg = "#000000", bold = true })

-- All other search matches
vim.api.nvim_set_hl(0, "Search", { bg = "#f5f590", fg = "#000000" })

-- Neovim 0.8+ also has CurSearch for the current match when navigating with n/N
vim.api.nvim_set_hl(0, "CurSearch", { bg = "#f76565", fg = "#ffffff", bold = true })

-- Line number color for lines with search matches isn't built-in,
-- but you can change the gutter colors globally like this:
-- vim.api.nvim_set_hl(0, "LineNr", { fg = "#555555" })         -- all line numbers
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#ffff00", bold = true }) -- current line number
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#333333" })                -- current line number

-- Autocommands to update highlights when switching windows or buffers
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
    callback = set_window_highlight,
})
vim.api.nvim_create_autocmd("WinLeave", {
    callback = set_window_highlight,
})

vim.api.nvim_set_hl(0, "SearchMatchIcon", { fg = "#f5f590" })
-- 1. Define the sign (character + highlight)
vim.fn.sign_define("SearchMatch", {
    text = "󰍉", -- any 1-2 char: ">>", "●", "󰍉 ", etc.
    texthl = "SearchMatchIcon", -- reuse Search highlight, or define your own
})

-- 2. Helper to place signs on all current search matches
local function place_search_signs()
    -- Clear previous search signs
    vim.fn.sign_unplace("search_matches")

    local pattern = vim.fn.getreg("/")
    if pattern == "" then return end

    local bufnr = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

    for i, line in ipairs(lines) do
        if vim.fn.match(line, pattern) ~= -1 then
            vim.fn.sign_place(0, "search_matches", "SearchMatch", bufnr, { lnum = i, priority = 10 })
        end
    end
end

-- 3. Trigger it when a search is confirmed
vim.api.nvim_create_autocmd("CmdlineLeave", {
    pattern = { "/", "?" },
    callback = function()
        vim.schedule(place_search_signs) -- schedule so the register is updated first
    end,
})

-- 4. Clear signs when search is cleared (e.g. :noh)
vim.api.nvim_create_autocmd("CmdlineLeave", {
    pattern = ":",
    callback = function()
        local cmd = vim.fn.getcmdline()
        if cmd == "noh" or cmd == "nohlsearch" then
            vim.fn.sign_unplace("search_matches")
        end
    end,
})
