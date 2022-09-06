local config = {}

config.i3cheese = {
	firenvim = vim.fn.exists("g:started_by_firenvim") == 1,
    macos = vim.fn.has('macunix') == 1,
}

config.options = {
	-- custom = {}
	-- general nvim/vim options , check :h optionname to know more about an option

	clipboard = "",
	hidden = true,
	ignorecase = true,
	smartcase = true,
	mapleader = " ",
	mouse = "a",
	number = true,
	numberwidth = 2,
	relativenumber = true,
	expandtab = true,
	shiftwidth = 4,
	smartindent = false,
	tabstop = 4,
	timeoutlen = 400,
	updatetime = 250,
	undofile = true,
	fillchars = { eob = " " },
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
		bufferline = false, -- manage and preview opened buffers
        
	},
    do_install = {
        mac_switcher = config.i3cheese.macos, 
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
