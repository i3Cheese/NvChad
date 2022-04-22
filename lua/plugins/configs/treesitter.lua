local present, ts_config = pcall(require, "nvim-treesitter.configs")

if not present then
	return
end

local default = {
	ensure_installed = {
		"lua",
		"vim",
		"python",
		"cpp",
		"yaml",
		"json",
		"html",
		"javascript",
	},
	highlight = {
		enable = true,
		use_languagetree = true,
	},
}

local M = {}
M.setup = function(override_flag)
	if override_flag then
		default = require("core.utils").tbl_override_req("nvim_treesitter", default)
	end
	ts_config.setup(default)
	local ft_to_parser = require("nvim-treesitter.parsers").filetype_to_parsername
	ft_to_parser.htmldjango = "html" -- the someft filetype will use the python parser and queries.
end

return M
