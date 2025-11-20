vim.api.nvim_create_user_command("PythonBlueprint", function()
  local lines = {
    "#!/usr/bin/env python3",
    "",
    "from __future__ import annotations",
    "",
    "def main() -> int:",
    "    return 0",
    "",
    "if __name__ == \"__main__\":",
    "    raise SystemExit(main())"
  }
  vim.api.nvim_buf_set_lines(0, 0, 0, false, lines)
end, {})
