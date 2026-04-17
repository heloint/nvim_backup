local function pretty_print(t, indent)
	indent = indent or 0
	local prefix = string.rep("  ", indent)

	if type(t) ~= "table" then
		print(prefix .. tostring(t))
		return
	end

	for k, v in pairs(t) do
		local key = type(k) == "string" and k or "[" .. tostring(k) .. "]"
		if type(v) == "table" then
			print(prefix .. key .. ":")
			pretty_print(v, indent + 1)
		else
			print(prefix .. key .. ": " .. tostring(v))
		end
	end
end

function get_branch_list()
	local result = vim.system({ "git", "branch", "-q" }, { text = true }):wait()

	local branches = {}
	for line in result.stdout:gmatch("[^\n]+") do
		local name = line:match("^%*?%s*(.+)$") -- strip leading "* " or "  "
		table.insert(branches, name)
	end

	return branches
end

local function exec_shell_with_notification(cmd)
	local result = vim.system(cmd, { text = true }):wait()
	if result.code ~= 0 then
		vim.notify(result.stderr, vim.log.levels.ERROR)
		return nil
	end
	vim.notify(result.stdout)
	return result.stdout
end

vim.api.nvim_create_user_command("Git", function(opts)
	local args = vim.split(opts.args, "%s+")
	if args[1] == "checkout" then
		local selected_branch = opts.fargs[2]

		if selected_branch == nil then
			print("No branch selected ...")
			return
		end

		pretty_print(selected_branch)
		exec_shell_with_notification({ "git", "checkout", selected_branch })
	elseif args[1] == "logs" then
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

		local original_ft = vim.bo[vim.api.nvim_get_current_buf()].filetype
		local git_root = vim.system({ "git", "rev-parse", "--show-toplevel" }, { text = true }):wait().stdout:gsub("\n$", "")
		local rel_path = bufname:sub(#git_root + 2)

		vim.cmd("tabnew")
		local preview_win = vim.api.nvim_get_current_win()
		local preview_buf = vim.api.nvim_create_buf(false, true)
		vim.bo[preview_buf].modifiable = false
		vim.bo[preview_buf].buftype = "nofile"
		vim.bo[preview_buf].bufhidden = "wipe"
		vim.bo[preview_buf].filetype = original_ft
		vim.api.nvim_buf_set_name(preview_buf, "git show: " .. vim.fn.fnamemodify(bufname, ":t"))
		vim.api.nvim_win_set_buf(preview_win, preview_buf)

		vim.cmd("botright 15split")
		local log_win = vim.api.nvim_get_current_win()
		local log_buf = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_buf_set_lines(log_buf, 0, -1, false, lines)
		vim.bo[log_buf].modifiable = false
		vim.bo[log_buf].buftype = "nofile"
		vim.bo[log_buf].bufhidden = "wipe"
		vim.api.nvim_buf_set_name(log_buf, "git log: " .. vim.fn.fnamemodify(bufname, ":t"))
		vim.api.nvim_win_set_buf(log_win, log_buf)

		local function update_preview()
			local line = vim.api.nvim_get_current_line()
			local hash = line:match("^(%x+)")
			if not hash then return end

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

	vim.cmd("checktime")
end, {
	nargs = "*",
	complete = function(arglead, cmdline, _)
		local args = vim.split(cmdline, "%s+")

		-- complete subcommands
		if #args == 2 then
			return vim.tbl_filter(function(s)
				return s:find("^" .. arglead)
			end, { "checkout", "status", "log", "logs" })
		end

		-- complete branch names after "checkout"
		if #args >= 3 and args[2] == "checkout" then
			return vim.tbl_filter(function(b)
				return b:find("^" .. arglead)
			end, get_branch_list())
		end

	end,
})
