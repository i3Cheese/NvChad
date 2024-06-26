local present, cmp = pcall(require, "cmp")

if not present then
	return
end

vim.opt.completeopt = "menuone,noselect"

local config = {
	snippet = {
		expand = function(args)
			require("snippy").expand_snippet(args.body)
		end,
	},
	formatting = {
		format = function(entry, vim_item)
			local icons = require("plugins.configs.lspkind_icons")
			vim_item.kind = string.format("%s %s", icons[vim_item.kind], vim_item.kind)

			vim_item.menu = ({
				nvim_lsp = "[LSP]",
				nvim_lua = "[Lua]",
				buffer = "[BUF]",
			})[entry.source.name]

			return vim_item
		end,
	},
	mapping = require("core.mappings").cmp(),
	sources = {
		{ name = "nvim_lsp" },
		{ name = "snippy" },
		{ name = "buffer" },
		{ name = "nvim_lua" },
		{ name = "path" },
	},
}

local M = {}
M.setup = function()
	cmp.setup(config)
end

return M
