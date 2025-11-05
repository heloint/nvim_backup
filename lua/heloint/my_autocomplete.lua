-- AUTOCOMPLETION SETUP USING THE BUILT-IN vim.lsp.completion.
-- ===========================================================
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        vim.lsp.completion.enable(true, args.data.client_id, args.buf, { autotrigger = true })

        vim.api.nvim_create_autocmd('CompleteChanged', {
            buffer = args.buf,
            callback = function()
                local info = vim.fn.complete_info({ 'selected' })
                local completionItem = vim.tbl_get(vim.v.completed_item, 'user_data', 'nvim', 'lsp', 'completion_item')
                if nil == completionItem then
                    return
                end

                vim.lsp.buf_request_all(
                    args.buf,
                    vim.lsp.protocol.Methods.completionItem_resolve,
                    completionItem,
                    function(resolvedItem)
                        local docs = vim.tbl_get(resolvedItem[args.data.client_id], 'result', 'documentation', 'value')
                        if nil == docs then
                            return
                        end

                        local winData = vim.api.nvim__complete_set(info['selected'], { info = docs })
                        if not winData.winid or not vim.api.nvim_win_is_valid(winData.winid) then
                            return
                        end

                        vim.api.nvim_win_set_config(winData.winid, { border = 'rounded' })
                        vim.treesitter.start(winData.bufnr, 'markdown')
                        vim.wo[winData.winid].conceallevel = 3

                        vim.api.nvim_create_autocmd({ 'TextChangedI' }, {
                            buffer = args.buf,
                            callback = function()
                                if vim.lsp.completion and type(vim.lsp.completion.trigger) == "function" then
                                    vim.lsp.completion.trigger()
                                end
                            end
                        })
                    end

                )
            end
        })
    end
})

vim.go.completeopt = 'menu,noselect,menuone,popup'

local pumMaps = {
    ['<Tab>'] = '<C-n>',
    ['<Down>'] = '<C-n>',
    ['<S-Tab>'] = '<C-p>',
    ['<Up>'] = '<C-p>',
    ['<CR>'] = '<C-y>',
}

for insertKmap, pumKmap in pairs(pumMaps) do
    vim.keymap.set(
        { 'i' },
        insertKmap,
        function()
            return vim.fn.pumvisible() == 1 and pumKmap or insertKmap
        end,
        { expr = true }
    )
end
