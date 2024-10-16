local M = {}

local config = require("core.config")

M.autopairs = function()
	local present1, autopairs = pcall(require, "nvim-autopairs")
	local present2, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")

	if present1 and present2 then
		local default = { fast_wrap = {} }
		autopairs.setup(default)

		local cmp = require("cmp")
		cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
	end
end

M.better_escape = function()
	require("better_escape").setup({
		mapping = "jk",
		timeout = config.plugins.options.esc_insertmode_timeout,
	})
end

M.blankline = function()
	local conf = {
        scope = { enabled = false },
	}
	require("ibl").setup(conf)
end

M.colorizer = function()
	local present, colorizer = pcall(require, "colorizer")
	if present then
		local default = {
			filetypes = {
				"*",
			},
			user_default_options = {
				RGB = true, -- #RGB hex codes
				RRGGBB = true, -- #RRGGBB hex codes
				names = false, -- "Name" codes like Blue
				RRGGBBAA = false, -- #RRGGBBAA hex codes
				rgb_fn = false, -- CSS rgb() and rgba() functions
				hsl_fn = false, -- CSS hsl() and hsla() functions
				css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
				css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn

				-- Available modes: foreground, background
				mode = "background", -- Set the display mode.
			},
		}
		colorizer.setup(default["filetypes"], default["user_default_options"])
		vim.cmd("ColorizerReloadAllBuffers")
	end
end

M.signature = function()
	local present, lspsignature = pcall(require, "lsp_signature")
	if present then
		local default = {
            always_trigger = false,
			bind = true,
			doc_lines = 0,
			floating_window = true,
			fix_pos = true,
			hint_enable = false,
            toggle_key = "<M-s>",
            toggle_key_flip_floatwin_setting = "<M-d>",
			hint_prefix = "󰋼 ",
			hint_scheme = "String",
			hi_parameter = "Search",
            timer_interval = 1000000000000,
			max_height = 22,
			max_width = 120, -- max_width of signature floating_window, line will be wrapped if exceed max_width
			handler_opts = {
				border = "single", -- double, single, shadow, none
			},
			zindex = 200, -- by default it will be on top of all floating windows, set to 50 send it to bottom
			padding = "", -- character to pad on left and right of signature can be ' ', or '|'  etc
		}
		lspsignature.setup(default)
	end
end

M.lsp_handlers = function()
	local function lspSymbol(name, icon)
		local hl = "DiagnosticSign" .. name
		vim.fn.sign_define(hl, { text = icon, numhl = hl, texthl = hl })
	end

	lspSymbol("Error", "󰅙")
	lspSymbol("Info", "󰋼")
	lspSymbol("Hint", "󰌵")
	lspSymbol("Warn", "")

	vim.diagnostic.config({
		virtual_text = {
			prefix = "",
		},
		signs = true,
		underline = true,
		update_in_insert = false,
	})

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "single",
	})
	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "single",
	})

	-- -- suppress error messages from lang servers
	-- vim.notify = function(msg, log_level)
	--     if msg:match "exit code" then
	--         return
	--     end
	--     if log_level == vim.log.levels.ERROR then
	--         vim.api.nvim_err_writeln(msg)
	--     else
	--         vim.api.nvim_echo({ { msg } }, true, {})
	--     end
	-- end
end

M.gitsigns = function()
	local present, gitsigns = pcall(require, "gitsigns")

	if present then
		local default = {
			signs = {
				add = { text = "│", },
				change = { text = "│", },
				delete = { text = "󰍵", },
				topdelete = { text = "‾", },
				changedelete = { text = "~", },
			},
		}
        vim.api.nvim_set_hl(0, "GitSignsAdd", { link = "DiffAdd" })
        vim.api.nvim_set_hl(0, "GitSignsAddNr", { link = "GitSignsAddNr" })
        vim.api.nvim_set_hl(0, "GitSignsChange", { link = "DiffChange" })
        vim.api.nvim_set_hl(0, "GitSignsChangeNr", { link = "GitSignsChangeNr" })
        vim.api.nvim_set_hl(0, "GitSignsChangedelete", { link = "DiffChangeDelete" })
        vim.api.nvim_set_hl(0, "GitSignsChangedeleteNr", { link = "GitSignsChangeNr" })
        vim.api.nvim_set_hl(0, "GitSignsDelete", { link = "DiffDelete" })
        vim.api.nvim_set_hl(0, "GitSignsDeleteNr", { link = "GitSignsDeleteNr" })
        vim.api.nvim_set_hl(0, "GitSignsTopdelete", { link = "DiffDelete" })
        vim.api.nvim_set_hl(0, "GitSignsTopdeleteNr", { link = "GitSignsDeleteNr" })




		gitsigns.setup(default)
	end
end

return M
