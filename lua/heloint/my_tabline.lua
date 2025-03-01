vim.o.showtabline = 2

local colors = {
  active_fg = "%#TabLineSel#",
  inactive_fg = "%#TabLine#",
  modified_fg = "%#WarningMsg#",
}

-- Global variable to track the first visible tab
_G.tabline_offset = 1

function _G.custom_tabline()
  local s = ""
  local total_tabs = vim.fn.tabpagenr('$')
  local max_tabs = 7 -- Number of tabs to display at once
  local current_tab = vim.fn.tabpagenr()

  -- Adjust tabline offset to keep the current tab in view
  if current_tab < _G.tabline_offset then
    _G.tabline_offset = current_tab
  elseif current_tab > _G.tabline_offset + max_tabs - 1 then
    _G.tabline_offset = current_tab - max_tabs + 1
  end

  local start_tab = _G.tabline_offset
  local end_tab = math.min(start_tab + max_tabs - 1, total_tabs)

  -- Show left scroll indicator if there are hidden tabs on the left
  if start_tab > 1 then
    s = s .. "%#TabLineFill#%999XX " -- Left Scroll Indicator
  end

  for i = start_tab, end_tab do
    local hl = (i == vim.fn.tabpagenr()) and colors.active_fg or colors.inactive_fg
    local bufnr = vim.fn.tabpagebuflist(i)[1]
    local bufname = vim.fn.bufname(bufnr) or '[No Name]'

    -- Truncate long buffer names
    if #bufname > 20 then
      bufname = bufname:sub(1, 20) .. "..."
    end

    local mod = vim.fn.getbufvar(bufnr, '&modified') == 1 and " ●" or ""

    -- Get LSP diagnostics count
    local errors = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.ERROR })
    local warnings = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.WARN })

    -- Format errors and warnings if they exist
    local diag_str = ""
    if errors > 0 then
      diag_str = diag_str .. " %#DiagnosticError# " .. errors .. " "
    end
    if warnings > 0 then
      diag_str = diag_str .. " %#DiagnosticWarn# " .. warnings .. " "
    end

    -- Make tabs clickable
    s = s .. "%" .. i .. "T" .. hl .. " " .. i .. ": " .. bufname .. mod .. diag_str .. " "
    s = s .. "%#TabLineFill#│"
  end

  -- Show right scroll indicator if there are hidden tabs on the right
  if end_tab < total_tabs then
    s = s .. "%#TabLineFill#%998XX " -- Right Scroll Indicator
  end

  s = s .. "%#TabLineFill#%T"  -- Reset tab selection
  return s
end

vim.o.tabline = "%!v:lua.custom_tabline()"

local function refresh_tabline()
  vim.cmd("redrawtabline")
end

vim.api.nvim_create_autocmd({ "TabEnter" }, {
  callback = refresh_tabline,
})

-- Set some highlight groups for better contrast
vim.cmd [[
  highlight TabLineSel ctermfg=15 ctermbg=4 guifg=#FFFFFF guibg=#005F87
  highlight TabLine ctermfg=7 ctermbg=0 guifg=#D3D3D3 guibg=#1E1E1E
  highlight TabLineFill ctermfg=0 ctermbg=0 guifg=#1E1E1E guibg=#1E1E1E
  highlight WarningMsg ctermfg=3 guifg=#EBCB8B
]]
