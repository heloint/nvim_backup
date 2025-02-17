-- Set the grep command based on the availability of ripgrep
if vim.fn.executable("rg") == 1 then
    -- Use ripgrep
    vim.opt.grepprg = "rg --fixed-strings --vimgrep --smart-case --no-require-git 2> /dev/null"
    vim.opt.grepformat = "%f:%l:%c:%m"

    -- If we used the grep in visual mode, then we want the exact match for the selected string.
    -- So we disable ripgrep's regex mode.
    vim.keymap.set("v", "<space>g", "y:silent grep --fixed-strings \"\"<left><c-r>0", {})
else
    -- Fallback to custom grep
    vim.opt.grepprg = "grep -rinI --exclude-dir={.git,node_modules,.next} $*"
    vim.opt.grepformat = "%f:%l:%m"

    -- If we used the grep in visual mode, then we want the exact match for the selected string.
    vim.keymap.set("v", "<space>g", "y:silent grep \"\"<left><c-r>0", {})
end

vim.keymap.set("n", "<space>g", ":silent grep \"\"<left>", {})
