-- Set the grep command based on the availability of ripgrep
if vim.fn.executable("rg") == 1 then
    -- Use ripgrep
    vim.opt.grepprg = "rg --vimgrep -uu --smart-case"
    vim.opt.grepformat = "%f:%l:%c:%m"
else
    -- Fallback to custom grep
    vim.opt.grepprg = "grep -rinI --exclude-dir={.git,node_modules,.next} $*"
    vim.opt.grepformat = "%f:%l:%m"
end
