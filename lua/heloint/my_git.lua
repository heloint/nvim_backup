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
			end, { "checkout", "status", "log" })
		end

		-- complete branch names after "checkout"
		if #args >= 3 and args[2] == "checkout" then
			return vim.tbl_filter(function(b)
				return b:find("^" .. arglead)
			end, get_branch_list())
		end
	end,
})
