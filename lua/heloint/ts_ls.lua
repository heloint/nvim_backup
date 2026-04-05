vim.api.nvim_create_autocmd("FileType", {
  pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
  once = true, -- run only once, not on every JS/TS file open
  callback = function()
    if vim.fn.executable("typescript-language-server") == 1 then
      vim.notify("Starting typescript-language-server...", vim.log.levels.INFO)
      vim.lsp.enable('ts_ls')
      return
    end

    vim.notify("Installing typescript-language-server...", vim.log.levels.INFO)

    vim.fn.jobstart("npm install -g typescript-language-server typescript", {
      on_exit = function(_, code)
        if code == 0 then
          vim.notify("typescript-language-server installed successfully! Starting the language server...", vim.log.levels.INFO)
          vim.lsp.enable('ts_ls')
        else
          vim.notify("Failed to install typescript-language-server", vim.log.levels.ERROR)
        end
      end,
    })
  end,
})

