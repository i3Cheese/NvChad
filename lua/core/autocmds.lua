local settings = require("core.utils").load_config().options.nvChad
-- uncomment this if you want to open nvim with a dir
-- vim.cmd [[ autocmd BufEnter * if &buftype != "terminal" | lcd %:p:h | endif ]]

-- Use relative & absolute line numbers in 'n' & 'i' modes respectively
-- vim.cmd[[ au InsertEnter * set norelativenumber ]]
-- vim.cmd[[ au InsertLeave * set relativenumber ]]

-- Don't show any numbers inside terminals
if not settings.terminal_numbers then
	vim.cmd([[ au TermOpen term://* setlocal nonumber norelativenumber | setfiletype terminal ]])
end

local filetypes_group = vim.api.nvim_create_augroup("i3Cheese-filetypes", {
    clear = true,
})
vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
    group = filetypes_group,
    pattern = "nearcrowd.com_v2_-TABLE-1-TBODY-1-TR-1-TD-1-DIV-*.txt",
    command = "set ft=go",
    desc = "Detect CrowdScript",
})
