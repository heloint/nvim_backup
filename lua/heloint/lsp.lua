local lsp_setups = {
    {
        lsp_config_name = "ts_ls",
        lsp_cli_executable = "typescript-language-server",
        lsp_cli_install_cmd = "npm install -g typescript-language-server typescript",
        file_type_patterns = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
    },
    {
        lsp_config_name = "basedpyright",
        lsp_cli_executable = "basedpyright",
        lsp_cli_install_cmd = "npm install -g basedpyright typescript",
        file_type_patterns = { "python" },
    },
    {
        lsp_config_name = "angularls",
        lsp_cli_executable = "ngserver",
        lsp_cli_install_cmd = "npm install -g @angular/language-server",
        file_type_patterns = { "javascript", "typescript", "typescriptreact","htmlangular", "html" },
    },
    {
        lsp_config_name = "emmet_ls",
        lsp_cli_executable = "emmet-ls",
        lsp_cli_install_cmd = "npm install -g emmet-ls",
        file_type_patterns = { "astro", "css", "eruby", "html", "htmlangular", "htmldjango", "javascriptreact", "less", "pug", "sass", "scss", "svelte", "templ", "typescriptreact", "vue", }
    },
    {
        lsp_config_name = "html",
        lsp_cli_executable = "vscode-html-language-server",
        lsp_cli_install_cmd = "npm install -g vscode-langservers-extracted",
        file_type_patterns = { "htmlangular", "html", "css", "javascript", }
    },
}


for i, lsp_setup in ipairs(lsp_setups) do

    vim.api.nvim_create_autocmd("FileType", {
        pattern = lsp_setup.file_type_patterns,
        once = true, -- run only once, not on every JS/TS file open
        callback = function()
            if vim.fn.executable(lsp_setup.lsp_cli_executable) == 1 then
                vim.lsp.enable(lsp_setup.lsp_config_name)
                return
            end

            vim.notify("Installing " .. lsp_setup.lsp_config_name .. " LSP", vim.log.levels.INFO)

            vim.fn.jobstart(lsp_setup.lsp_cli_install_cmd, {
                on_exit = function(_, code)
                    if code == 0 then
                        vim.lsp.enable(lsp_setup.lsp_config_name)
                    else
                        vim.notify("Failed to install " .. lsp_setup.lsp_config_name .. " LSP", vim.log.levels.ERROR)
                    end
                end,
            })
        end,
    })

end


-- ADDITIONAL CONFIGS
-- ==================

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
