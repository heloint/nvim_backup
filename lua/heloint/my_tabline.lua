vim.o.showtabline = 2

local colors = {
  active_fg = "%#TabLineSel#",
  inactive_fg = "%#TabLine#",
  modified_fg = "%#WarningMsg#",
}

function _G.custom_tabline()
  local s = ""
  for i = 1, vim.fn.tabpagenr('$') do
    local hl = (i == vim.fn.tabpagenr()) and colors.active_fg or colors.inactive_fg
    local bufname = vim.fn.bufname(vim.fn.tabpagebuflist(i)[1]) or '[No Name]'
    local mod = vim.fn.getbufvar(vim.fn.tabpagebuflist(i)[1], '&modified') == 1 and " ●" or ""
    s = s .. hl .. " " .. i .. ": " .. bufname .. mod .. " "
    s = s .. "%#TabLineFill#│"
  end
  return s
end

vim.o.tabline = "%!v:lua.custom_tabline()"

-- Set some highlight groups for better contrast
vim.cmd [[
  highlight TabLineSel ctermfg=15 ctermbg=4 guifg=#FFFFFF guibg=#005F87
  highlight TabLine ctermfg=7 ctermbg=0 guifg=#D3D3D3 guibg=#1E1E1E
  highlight TabLineFill ctermfg=0 ctermbg=0 guifg=#1E1E1E guibg=#1E1E1E
  highlight WarningMsg ctermfg=3 guifg=#EBCB8B
]]
