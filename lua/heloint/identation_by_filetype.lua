function set_identation_by_filetype(args)
    for i, filetype in ipairs(args["filetypes"]) do
        vim.api.nvim_create_autocmd("FileType", {
            pattern = args["filetype"],
            callback = function()
                vim.opt_local.shiftwidth = args["shiftwidth"]
                vim.opt_local.tabstop = args["tabstop"]
            end
        })
    end
end

set_identation_by_filetype ({
    filetypes = {"html", "tsx", "jsp", "jsx", "js", "ts"},
    shiftwidth = 2,
    tabstop = 2
})

set_identation_by_filetype ({
    filetypes = {"py", "go", "rs", "php"},
    shiftwidth = 4,
    tabstop = 4
})
