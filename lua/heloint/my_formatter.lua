local formatprgs = {
    python = "black --stdin-filename %",
    typescript = "prettier --tab-width 4 --stdin-filepath %",
    javascript = "prettier --tab-width 4 --stdin-filepath %"
}


-- Create a group for your autocommands
local group = vim.api.nvim_create_augroup("PrintLala", { clear = true })

-- Print "lala" when entering a new buffer
vim.api.nvim_create_autocmd("BufEnter", {
    group = group,
    callback = function()
        local filetype = vim.bo.filetype -- Get the current buffer's file type
        vim.o.formatprg = formatprgs[filetype]
        -- print("File type:", filetype)
    end,
})

-- Print "lala" when entering a new window
vim.api.nvim_create_autocmd("WinEnter", {
    group = group,
    callback = function()
        local filetype = vim.bo.filetype -- Get the current buffer's file type
        vim.o.formatprg = formatprgs[filetype]
        -- print("File type:", filetype)
    end,
})
