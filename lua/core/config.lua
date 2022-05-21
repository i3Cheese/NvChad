-- IMPORTANT NOTE : This is default config, so dont change anything here.
-- use custom/chadrc.lua instead

local config = {}

config.i3cheese = {
	firenvim = vim.fn.exists("g:started_by_firenvim") == 1,
}

config.options = {
	-- custom = {}
	-- general nvim/vim options , check :h optionname to know more about an option

	clipboard = "",
	hidden = true,
	ignorecase = true,
	smartcase = true,
	mapleader = " ",
	mouse = "",
	number = true,
	numberwidth = 2,
	relativenumber = true,
	expandtab = true,
	shiftwidth = 4,
	smartindent = true,
	tabstop = 4,
	timeoutlen = 400,
	updatetime = 250,
	undofile = true,
	fillchars = { eob = " " },
	shadafile = vim.opt.shadafile,

}

---- UI -----

config.ui = {
    guifont = "Hack Nerd Font",
    guifontsize = "h21",

	hl_override = "", -- path of your file that contains highlights
	italic_comments = false,
	theme = "wombat", -- default theme

	-- Change terminal bg to nvim theme's bg color so it'll match well
	-- For Ex : if you have onedark set in nvchad, set onedark's bg color on your terminal
	transparency = false,
}

---- PLUGIN OPTIONS ----

config.plugins = {
	-- enable/disable plugins (false for disable)
	status = {
        firenvim = false,
		bufferline = true, -- manage and preview opened buffers
	},
	options = {
		esc_insertmode_timeout = 300,
	},
	install = nil,
}


local firenvim_config = {
	plugins = {
		status = {
            firenvim = true,
			bufferline = false,
		},
	},
}

if config.i3cheese.firenvim then
	config = vim.tbl_deep_extend("force", config, firenvim_config)
end

return config
