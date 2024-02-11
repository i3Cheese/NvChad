local opt = vim.opt
opt.title = true
opt.titlelen = 40

local M = {}
M.changed_string = function()
	if require("core.utils").is_unsaved_buffers_exist() then
		return "!!!"
	else
		return ""
	end
end
function M.set_title()
	vim.opt.titlestring = [[%{luaeval("require('core.title').titlestring()")}]]
end

function M.titlestring()
    local blocks = {
        " ",
        vim.fn.fnamemodify(vim.fn.getcwd(), ":t"),
        M.changed_string(),
    }
    local title = ""
    for _, block in ipairs(blocks) do
        title = title .. block
    end
    return title
end

M.setup = function()
	M.set_title()
	-- local title_group = vim.api.nvim_create_augroup("TitleGroup", { clear = true })
	-- vim.api.nvim_create_autocmd("DirChanged", {
	-- 	group = title_group,
	-- 	callback = M.set_title,
	-- })
end

return M
