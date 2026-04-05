vim.lsp.config("basedpyright", {
  settings = {
    basedpyright = {
      typeCheckingMode = "standard", -- "off" | "basic" | "standard" | "strict" | "all"
      disableBytesTypePromotions = false,
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "workspace", -- only check open files, not the whole project
        -- ignore = { "*" },                 -- ignore all files (most aggressive)
      },
    },
  },
})


vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python" },
  once = true, -- run only once, not on every Python file open
  callback = function()
    if vim.fn.executable("basedpyright") == 1 then
      vim.notify("Starting basedpyright...", vim.log.levels.INFO)
      vim.lsp.enable("basedpyright")
      return
    end

    vim.notify("Installing basedpyright...", vim.log.levels.INFO)

    vim.fn.jobstart("npm install -g basedpyright typescript", {
      on_exit = function(_, code)
        if code == 0 then
          vim.notify("basedpyright installed successfully! Starting the language server...", vim.log.levels.INFO)
          vim.lsp.enable("basedpyright")
        else
          vim.notify("Failed to install basedpyright", vim.log.levels.ERROR)
        end
      end,
    })
  end,
})


