local present, bufferline = pcall(require, "bufferline")
if not present then
	return
end
local default = {
	colors = require("colors").get(),
}
default = {
	options = {
		offsets = { { filetype = "NvimTree", text = "", padding = 1 } },
		modified_icon = "",
		show_close_icon = false,
        show_buffer_close_icons = false,
		left_trunc_marker = "",
		right_trunc_marker = "",
		max_name_length = 14,
		max_prefix_length = 13,
		tab_size = 20,
		show_tab_indicators = true,
		enforce_regular_tabs = false,
		view = "multiwindow",
		separator_style = "thick",
		always_show_bufferline = true,
		diagnostics = false,
		-- custom_filter = function(buf_number)
		-- 	-- Func to filter out our managed/persistent split terms
		-- 	local present_type, type = pcall(function()
		-- 		return vim.api.nvim_buf_get_var(buf_number, "term_type")
		-- 	end)
		--
		-- 	if present_type then
		-- 		if type == "vert" then
		-- 			return false
		-- 		elseif type == "hori" then
		-- 			return false
		-- 		end
		-- 		return true
		-- 	end
		--
		-- 	return true
		-- end,
	},

	highlights = {
		background = {
			guifg = default.colors.grey_fg,
			guibg = default.colors.one_bg2,
		},

		-- buffers
		buffer_selected = {
			guifg = default.colors.white,
			guibg = default.colors.bg,
			gui = "bold",
		},
		buffer_visible = {
			guifg = default.colors.light_grey,
			guibg = default.colors.bg,
		},

		fill = {
			guifg = default.colors.grey_fg,
			guibg = default.colors.one_bg2,
		},
		indicator_selected = {
			guifg = default.colors.blue,
			guibg = default.colors.bg,
		},

		-- modified
		modified = {
			guifg = default.colors.red,
			guibg = default.colors.black2,
		},
		modified_visible = {
			guifg = default.colors.red,
			guibg = default.colors.black2,
		},
		modified_selected = {
			guifg = default.colors.green,
			guibg = default.colors.black,
		},

		-- separators
		separator_selected = {
			guifg = default.colors.blue,
			guibg = default.colors.blue,
		},
		separator = {
			guifg = default.colors.bg,
			guibg = default.colors.one_bg2,
		},
		separator_visible = {
			guifg = default.colors.bg,
			guibg = default.colors.one_bg2,
		},

		-- tabs
		tab = {
			guifg = default.colors.light_grey,
			guibg = default.colors.one_bg3,
		},
		tab_selected = {
			guifg = default.colors.black2,
			guibg = default.colors.nord_blue,
		},
		tab_close = {
			guifg = default.colors.red,
			guibg = default.colors.black,
		},
	},
}

local M = {}
M.setup = function()
	bufferline.setup(default)
end

return M
