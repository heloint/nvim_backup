local function get_branch_list()
	local result = vim.system({ "git", "branch", "-q" }, { text = true }):wait()
	if result.code ~= 0 then
		vim.notify("Failed to get branches: " .. result.stderr, vim.log.levels.ERROR)
		return {}
	end

	local branches = {}
	for _, line in ipairs(vim.split(result.stdout, "\n", { trimempty = true })) do
		local name = line:match("^%*?%s*(.+)$")
		if name then table.insert(branches, name) end
	end
	return branches
end

local function exec_shell_with_notification(cmd)
	local result = vim.system(cmd, { text = true }):wait()
	if result.code ~= 0 then
		vim.notify(result.stderr, vim.log.levels.ERROR)
		return nil
	end
	vim.notify(result.stdout, vim.log.levels.INFO)
	return result.stdout
end

local function make_scratch_buf(name, filetype)
	local buf = vim.api.nvim_create_buf(false, true)
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].bufhidden = "wipe"
	if filetype then vim.bo[buf].filetype = filetype end
	vim.api.nvim_buf_set_name(buf, name)
	return buf
end

vim.api.nvim_create_user_command("Git", function(opts)
	local subcmd = opts.fargs[1]

	if subcmd == "checkout" then
		local selected_branch = opts.fargs[2]
		if not selected_branch then
			vim.notify("No branch selected", vim.log.levels.WARN)
			return
		end
		exec_shell_with_notification({ "git", "checkout", selected_branch })
		vim.cmd("checktime")

	elseif subcmd == "logs" then
		local bufname = vim.api.nvim_buf_get_name(0)
		if bufname == "" then
			vim.notify("No file in current buffer", vim.log.levels.WARN)
			return
		end

		local result = vim.system({ "git", "log", "--oneline", "--", bufname }, { text = true }):wait()
		if result.code ~= 0 then
			vim.notify(result.stderr, vim.log.levels.ERROR)
			return
		end

		local lines = vim.split(result.stdout, "\n", { trimempty = true })
		if #lines == 0 then
			vim.notify("No commits found for " .. vim.fn.fnamemodify(bufname, ":t"), vim.log.levels.INFO)
			return
		end

		local original_ft = vim.bo[0].filetype
		local git_root = vim.system({ "git", "rev-parse", "--show-toplevel" }, { text = true }):wait().stdout:gsub("\n$", "")
		local rel_path = bufname:sub(#git_root + 2)
		local short_name = vim.fn.fnamemodify(bufname, ":t")

		vim.cmd("tabnew")
		local preview_win = vim.api.nvim_get_current_win()
		local preview_buf = make_scratch_buf("git show: " .. short_name, original_ft)
		vim.bo[preview_buf].modifiable = false
		vim.api.nvim_win_set_buf(preview_win, preview_buf)

		vim.cmd("botright 15split")
		local log_win = vim.api.nvim_get_current_win()
		local log_buf = make_scratch_buf("git log: " .. short_name)
		vim.api.nvim_buf_set_lines(log_buf, 0, -1, false, lines)
		vim.bo[log_buf].modifiable = false
		vim.api.nvim_win_set_buf(log_win, log_buf)

		local last_hash = nil
		local function update_preview()
			local line = vim.api.nvim_get_current_line()
			local hash = line:match("^(%x+)")
			if not hash or hash == last_hash then return end
			last_hash = hash

			local show_result = vim.system({ "git", "show", hash .. ":" .. rel_path }, { text = true }):wait()
			local content
			if show_result.code ~= 0 then
				content = { "Error: " .. (show_result.stderr or "") }
			else
				content = vim.split(show_result.stdout, "\n", { trimempty = false })
			end

			vim.bo[preview_buf].modifiable = true
			vim.api.nvim_buf_set_lines(preview_buf, 0, -1, false, content)
			vim.bo[preview_buf].modifiable = false
		end

		update_preview()

		local augroup = vim.api.nvim_create_augroup("GitLogsPreview_" .. log_buf, { clear = true })
		vim.api.nvim_create_autocmd("CursorMoved", {
			group = augroup,
			buffer = log_buf,
			callback = update_preview,
		})
		vim.api.nvim_create_autocmd("BufWipeout", {
			group = augroup,
			buffer = log_buf,
			callback = function()
				vim.api.nvim_del_augroup_by_id(augroup)
			end,
		})
	end
end, {
	nargs = "*",
	complete = function(arglead, cmdline, _)
		local args = vim.split(cmdline, "%s+")

		if #args == 2 then
			return vim.tbl_filter(function(s)
				return s:find("^" .. arglead)
			end, { "checkout", "status", "log", "logs" })
		end

		if #args >= 3 and args[2] == "checkout" then
			return vim.tbl_filter(function(b)
				return b:find("^" .. arglead)
			end, get_branch_list())
		end
	end,
})
