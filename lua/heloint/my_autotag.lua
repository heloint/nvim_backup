local ag = vim.api.nvim_create_augroup("autotag", { clear = true })

local self_closing = {
    br = true,
    img = true,
    input = true,
    hr = true,
    meta = true,
    link = true
}
local html_filetypes = {
    "html",
    "markdown",
    "javascriptreact",
    "typescriptreact",
    "vue",
    "svelte",
    "xml",
    "htmlangular"
}

local autotag_state = {
	is_opened = false,
	is_whitespace_hit = false,
	tag_body = "",
	line_num = -1,
}

local function reset_autotag_state()
	autotag_state.is_opened = false
	autotag_state.is_whitespace_hit = false
	autotag_state.tag_body = ""
	autotag_state.line_num = -1
end

local function detect_and_handle_line_change()
	-- If we hit new line, then don't autoclose the tag.
	-- The reason is, because I don't like it.
	local curr_row = vim.api.nvim_win_get_cursor(0)[1]
	if autotag_state.line_num == -1 then
		autotag_state.line_num = curr_row
	elseif autotag_state.line_num ~= curr_row then
		reset_autotag_state()
	end
end

local function handle_closing_tag_insertion()

    local current_line_content = vim.api.nvim_get_current_line()

    local buffer = ""
    for i = #current_line_content, 1, -1 do
        local char = current_line_content:sub(i, i)

        if char:match("%s") then
            buffer = ""
        elseif char == "<" then
            break
        else
            buffer = buffer .. char
        end
    end

    local flipped = ""
    for i = #buffer, 1, -1 do
        flipped = flipped .. buffer:sub(i, i)
    end

    autotag_state.tag_body = flipped

	if self_closing[autotag_state.tag_body] then
		return
	end

	-- Do not touch this, if you don't want to go recursive.
	autotag_state.is_opened = false

	local closing_tag = "</" .. autotag_state.tag_body .. ">"
	local left_spam = vim.api.nvim_replace_termcodes(string.rep("<Left>", #closing_tag), true, false, true)

	vim.api.nvim_feedkeys(closing_tag .. left_spam, "i", false)
	reset_autotag_state()
end

vim.api.nvim_create_autocmd("FileType", {
	group = ag,
	pattern = html_filetypes,
	callback = function()
		vim.api.nvim_create_autocmd("InsertCharPre", {
			group = ag,
            buffer = 0,
			callback = function()
				detect_and_handle_line_change()

				if vim.v.char == "<" then
					reset_autotag_state()
					autotag_state.is_opened = true
					return
				end

				if vim.v.char == "/" then
					reset_autotag_state()
					return
				end

				if vim.v.char == ">" and autotag_state.is_opened then
					handle_closing_tag_insertion()
					return
				end

                if vim.v.char:match("%s") then
                    autotag_state.is_whitespace_hit = true
                end

			end,
		})

		vim.api.nvim_create_autocmd("InsertLeave", {
			group = ag,
            buffer = 0,
			callback = function()
				reset_autotag_state()
			end,
		})
	end,
})
