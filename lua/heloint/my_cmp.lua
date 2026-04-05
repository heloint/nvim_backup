vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- Use LSP omnifunc
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    vim.bo[args.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
  end,
})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    -- Enable completion triggered by <C-x><C-o>
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end
  end,
})

vim.lsp.config('*', {
  handlers = {
    ['textDocument/hover'] = function(err, result, ctx, config)
      vim.lsp.handlers.hover(err, result, ctx, vim.tbl_extend('force', config or {}, {
        border = 'rounded'
      }))
    end,
    ['textDocument/signatureHelp'] = function(err, result, ctx, config)
      vim.lsp.handlers.signature_help(err, result, ctx, vim.tbl_extend('force', config or {}, {
        border = 'rounded'
      }))
    end,
  }
})
