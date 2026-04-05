local M = {}
local active_buffers = {}

function M.toggle(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  local filename = vim.api.nvim_buf_get_name(buf)
  local ext = filename:match("%.(%w+)$")

  if ext ~= "csv" and ext ~= "tsv" then return end

  if active_buffers[buf] then
    M.disable(buf)
  else
    M.enable(buf)
  end
end

function M.enable(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  local sep = vim.api.nvim_buf_get_name(buf):match("%.tsv$") and "\t" or ","

  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

  -- Parse rows
  local rows = {}
  for _, line in ipairs(lines) do
    local row = {}
    for field in (line .. sep):gmatch("([^" .. sep .. "]*)" .. sep) do
      table.insert(row, field)
    end
    table.insert(rows, row)
  end

  -- Calculate column widths
  local widths = {}
  for _, row in ipairs(rows) do
    for i, field in ipairs(row) do
      widths[i] = math.max(widths[i] or 0, #field)
    end
  end

  -- Render virtual lines
  local ns = vim.api.nvim_create_namespace("csv_pretty")
  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

  for i, row in ipairs(rows) do
    local cells = {}
    for j, field in ipairs(row) do
      table.insert(cells, field .. string.rep(" ", widths[j] - #field))
    end
    local vtext = table.concat(cells, " │ ")

    vim.api.nvim_buf_set_extmark(buf, ns, i - 1, 0, {
      virt_text = {{ vtext, "Normal" }},
      virt_text_pos = "overlay",
    })
  end

  -- Build column start positions in the rendered virtual line
  -- Format: col0_content │ col1_content │ ...  (separator = " │ " = 3 chars)
  local col_starts = {}
  local pos = 0
  for _, w in ipairs(widths) do
    table.insert(col_starts, pos)
    pos = pos + w + 3
  end

  -- Hide the real text
  vim.wo.conceallevel = 3
  vim.wo.concealcursor = "nvic"
  vim.wo.virtualedit = "all"

  -- Jump to next column
  vim.keymap.set("n", "w", function()
    local cur_col = vim.api.nvim_win_get_cursor(0)[2]
    local row = vim.api.nvim_win_get_cursor(0)[1]
    for _, start in ipairs(col_starts) do
      if start > cur_col then
        vim.api.nvim_win_set_cursor(0, { row, start })
        return
      end
    end
  end, { buffer = buf, desc = "CSV: next column" })

  -- Jump to previous column
  vim.keymap.set("n", "b", function()
    local cur_col = vim.api.nvim_win_get_cursor(0)[2]
    local row = vim.api.nvim_win_get_cursor(0)[1]
    local prev = nil
    for _, start in ipairs(col_starts) do
      if start < cur_col then
        prev = start
      end
    end
    if prev then
      vim.api.nvim_win_set_cursor(0, { row, prev })
    end
  end, { buffer = buf, desc = "CSV: prev column" })

  active_buffers[buf] = true
end

function M.disable(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  local ns = vim.api.nvim_create_namespace("csv_pretty")
  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
  vim.wo.conceallevel = 0
  vim.wo.virtualedit = ""
  pcall(vim.keymap.del, "n", "w", { buffer = buf })
  pcall(vim.keymap.del, "n", "b", { buffer = buf })
  active_buffers[buf] = nil
end

vim.api.nvim_create_user_command("CsvToggle", function()
  M.toggle()
end, {})
