local to_always_ignore = {
    "*/remote-source/*",
    "*/node_modules/*",
    "_site",
    "*/__pycache__/*",
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
    "*/.fdb_latexmk",
    "*/.next/*",
}

for idx, val in ipairs(to_always_ignore) do
    vim.opt.wildignore:append(val)
end
-- Function to add "*/" at the start and "/*" at the end of each string in an array
local function add_stars_to_paths(array)
    local result = {}

    for _, value in ipairs(array) do
        -- Transform each element and add it to the result array
        table.insert(result, "*/" .. value .. "/*")
    end

    return result
end


-- Function to join two string arrays
local function join_string_arrays(array1, array2)
    -- Create a new table to hold the combined arrays
    local result = {}

    -- Insert elements from the first array
    for _, value in ipairs(array1) do
        table.insert(result, value)
    end

    -- Insert elements from the second array
    for _, value in ipairs(array2) do
        table.insert(result, value)
    end

    return result
end

-- Function to get all ignored paths
local function get_all_git_ignored_paths()
    -- Run the git command to get all ignored directory paths
    local directory_results = vim.fn.systemlist("git check-ignore **/*")
    -- Check for errors by inspecting the exit code
    if vim.v.shell_error ~= 0 then
        print("Error running git ls-files command")
        return nil
    end
    directory_results = add_stars_to_paths(directory_results)

    -- Run the git command to get all ignored file paths
    local file_results = vim.fn.systemlist("git check-ignore **")
    -- Check for errors by inspecting the exit code
    if vim.v.shell_error ~= 0 then
        print("Error running git ls-files command")
        return nil
    end

    local combined_array = join_string_arrays(file_results, directory_results)
    -- Return the list of ignored paths
    return combined_array
end

-- Example usage: print each ignored path
local ignored_paths = get_all_git_ignored_paths()
if ignored_paths then
    for _, path in ipairs(ignored_paths) do
        vim.opt.wildignore:append(path)
    end
end


