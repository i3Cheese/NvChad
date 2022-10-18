local present, impatient = pcall(require, "impatient")

if present then
	impatient.enable_profile()
end

require("globals")
local core_modules = {
	"core.options",
	"core.autocmds",
	"core.mappings",
}

for _, module in ipairs(core_modules) do
	local ok, err = pcall(require, module)
	if not ok then
		error("Error loading " .. module .. "\n\n" .. err)
	end
end

-- vim.opt.runtimepath:append("~/.config/nvim/md-to-pdf.nvim/")
require("md-to-pdf").setup()

require("core.title").setup()
require("colors").init()
require("plugins")()
require("hsecpp").setup()


-- non plugin mappings
local mappings = require("core.mappings")
mappings.misc()
mappings.entrypoints()
