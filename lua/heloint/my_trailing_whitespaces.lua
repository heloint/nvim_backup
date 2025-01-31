local config = {
    highlight = 'DiffDelete',
    ignored_filetypes = { 'TelescopePrompt', 'Trouble', 'help', 'dashboard' },
    ignore_terminal = true,
    return_cursor = true,
}

local whitespace = {}

whitespace.nohighlight = function()
    vim.cmd('match')
end

whitespace.highlight = function()
    if not vim.fn.hlexists(config.highlight) then
        error(string.format('highlight %s does not exist', config.highlight))
    end

    local command = string.format([[match %s /\s\+$/]], config.highlight)
    vim.cmd(command)
end

whitespace.trim = function()
    local save_cursor = vim.fn.getpos(".")
    vim.cmd [[keeppatterns %substitute/\v\s+$//eg]]
    if config.return_cursor then
        vim.fn.setpos(".", save_cursor)
    end
end

local function file_type()
    if vim.tbl_contains(config.ignored_filetypes, vim.bo.filetype) then
        whitespace.nohighlight()
    else
        whitespace.highlight()
    end
end

local function term_open()
    if config.ignore_terminal then
        whitespace.nohighlight()
    else
        whitespace.highlight()
    end
end

local function buf_enter()
    if vim.tbl_contains(config.ignored_filetypes, vim.bo.filetype) or (config.ignore_terminal and vim.bo.buftype == 'terminal') then
        whitespace.nohighlight()
    else
        whitespace.highlight()
    end
end

whitespace.setup = function(options)
    config = vim.tbl_extend('force', config, options or {})

    vim.api.nvim_create_augroup('whitespace_nvim', { clear = true })
    vim.api.nvim_create_autocmd('FileType', { group = 'whitespace_nvim', pattern = '*', callback = file_type })
    vim.api.nvim_create_autocmd('TermOpen', { group = 'whitespace_nvim', pattern = '*', callback = term_open })
    vim.api.nvim_create_autocmd('BufEnter', { group = 'whitespace_nvim', pattern = '*', callback = buf_enter })
end

whitespace.setup({
    -- configuration options and their defaults

    -- `highlight` configures which highlight is used to display
    -- trailing whitespace
    highlight = 'DiffDelete',

    -- `ignored_filetypes` configures which filetypes to ignore when
    -- displaying trailing whitespace
    --
    ignored_filetypes = { 'TelescopePrompt', 'Trouble', 'help', 'dashboard', "mason", "lazy_backdrop", "lazy" },

    -- `ignore_terminal` configures whether to ignore terminal buffers
    ignore_terminal = true,

    -- `return_cursor` configures if cursor should return to previous
    -- position after trimming whitespace
    return_cursor = true,
})
