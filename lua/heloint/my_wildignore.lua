local patterns_to_ignore = {
    "*/node_modules/*",
    "*/build/*",
    "_site",
    "*/__pycache__/",
    "*/venv/*",
    "*/target/*",
    "*/.vim$",
    "\\~$",
    "*/.log",
    "*/.cls",
    "*/.aux",
    "*/.bbl",
    "*/.blg",
    "*/.fls",
    "*/.fdb*/",
    "*/.toc",
    "*/.out",
    "*/.glo",
    "*/.ist",
    "*/.fdb_latexmk",
    "*.py[cod]",
    "*$py.class",
    "*.so",
    ".Python",
}

for _, pattern in ipairs(patterns_to_ignore) do
    vim.opt.wildignore:append(pattern)
end

