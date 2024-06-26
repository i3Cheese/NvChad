local M = {}

M.setup = function()
	require("nnn").setup({
		picker = {
			cmd = "nnn", -- command override (-p flag is implied)
            width = 80,
			style = {
				height = 0.8, -- ^
				xoffset = 0.5, -- ^
				yoffset = 0.5, -- ^
				border = "single", -- border decoration for example "rounded"(:h nvim_open_win)
			},
		},
		auto_open = {
			setup = nil, -- or "explorer" / "picker", auto open on setup function
			tabpage = nil, -- or "explorer" / "picker", auto open when opening new tabpage
			empty = false, -- only auto open on empty buffer
			ft_ignore = { -- dont auto open for these filetypes
				"gitcommit",
			},
		},
		auto_close = false, -- close tabpage/nvim when nnn is last window
		mappings = {}, -- table containing mappings, see below
		buflisted = false, -- wether or not nnn buffers show up in the bufferlist
	})
end

return M
