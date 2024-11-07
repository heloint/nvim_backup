local to_always_ignore = {
    "*/node_modules/*",
    "_site",
    "*/__pycache__/",
    "*/venv/*",
    "*/target/*",
    "*/.vim$",
    "\\~$",
    "*/.log",
    "*/.aux",
    "*/.cls",
    "*/.aux",
    "*/.bbl",
    "*/.blg",
    "*/.fls",
    "*/.fdb*/",
    "*/.toc",
    "*/.out",
    "*/.glo",
    "*/.log",
    "*/.ist",
    "*/.fdb_latexmk"
}

for idx, val in ipairs(to_always_ignore) do
    vim.opt.wildignore:append(val)
end

-- Function to get the parent directory of a given path
local function get_parent_directory(path)
    -- Remove the last part of the path (e.g., /file or /directory)
    local result = path:match("(.*/)")
    if result == "" or result == nil then
        result = "."
    end
    return result
end

-- Function to check if string contains ","
local function contains_comma(str)
    return string.find(str, ",") ~= nil
end

-- Function to read .gitignore and add entries to wildignore
local function add_gitignore_to_wildignore()
    -- Get the root directory of the current project
    local root_dir = vim.fn.finddir('.git', ';') -- Looks up to root
    if root_dir == "" then
        root_dir = "./"
    else
        root_dir = get_parent_directory(root_dir)
    end

    -- Construct the .gitignore path
    local gitignore_path = root_dir .. "/.gitignore"

    -- Check if .gitignore exists
    if vim.fn.filereadable(gitignore_path) == 0 then return end

    -- Read the .gitignore file
    local lines = vim.fn.readfile(gitignore_path)

    -- Filter and add entries to wildignore
    for _, line in ipairs(lines) do
        -- Ignore comments and blank lines
        if not line:match("^#") and line:match("%S") and not contains_comma(line) then
            -- Replace any leading "!" (negations in .gitignore) for compatibility with wildignore
            line = line:gsub("^!", "")
            line = line:gsub("^%**", "*")
            -- Add entry to wildignore
            vim.opt.wildignore:append(line)
        end
    end
    vim.opt.wildignore:remove('')
end

-- Run the function to add .gitignore entries to wildignore
add_gitignore_to_wildignore()
