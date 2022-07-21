local opt = vim.opt
local g = vim.g

local config = require("core.config")
local options = config.options
local ui = config.ui

opt.spelllang = "en,ru"
opt.langmap = "ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯЖ;ABCDEFGHIJKLMNOPQRSTUVWXYZ:,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz"

-- GUI

opt.guifont = ui.guifont .. ":" .. ui.guifontsize

opt.clipboard = options.clipboard
opt.cul = true -- cursor line

-- Indentline
opt.expandtab = options.expandtab
opt.shiftwidth = options.shiftwidth
opt.smartindent = options.smartindent

-- disable tilde on end of buffer: https://github.com/neovim/neovim/pull/8546#issuecomment-643643758
opt.fillchars = options.fillchars

opt.hidden = options.hidden
opt.ignorecase = options.ignorecase
opt.smartcase = options.smartcase
opt.mouse = options.mouse

-- Numbers
opt.number = options.number
opt.numberwidth = options.numberwidth
opt.relativenumber = options.relativenumber
opt.ruler = false

-- disable nvim intro
opt.shortmess:append("sI")

opt.showbreak = ">  \\"
opt.signcolumn = "yes"
opt.splitbelow = true
opt.splitright = true
opt.tabstop = options.tabstop
opt.termguicolors = true
opt.timeoutlen = options.timeoutlen
opt.undofile = options.undofile

-- interval for writing swap file to disk, also used by gitsigns
opt.updatetime = options.updatetime

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append("<>[]hl")

g.mapleader = options.mapleader

g.python3_host_prog = "~/python/venvs/neovim/bin/python"
g.pyindent_open_paren = 'shiftwidth()'
g.pyindent_nested_paren = 'shiftwidth()'
g.pyindent_continue = '0'

-- disable some builtin vim plugins
local disabled_built_ins = {
	"2html_plugin",
	"getscript",
	"getscriptPlugin",
	"gzip",
	"logipat",
	"matchit",
	"tar",
	"tarPlugin",
	"rrhelper",
	"vimball",
	"vimballPlugin",
	"zip",
	"zipPlugin",
}

for _, plugin in pairs(disabled_built_ins) do
	g["loaded_" .. plugin] = 1
end

