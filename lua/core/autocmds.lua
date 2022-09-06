-- vim.cmd [[ autocmd BufEnter * if &buftype != "terminal" | lcd %:p:h | endif ]]

-- Use relative & absolute line numbers in 'n' & 'i' modes respectively
vim.cmd([[ au InsertEnter * set norelativenumber ]])
vim.cmd([[ au InsertLeave * set relativenumber ]])

-- Don't show any numbers inside terminals
vim.cmd([[ au TermOpen term://* setlocal nonumber norelativenumber | setfiletype terminal ]])

shada_au = vim.api.nvim_create_augroup("SHADA", { clear = true })
vim.api.nvim_create_autocmd("FocusLost", {
	group = shada_au,
	command = "wshada",
})
vim.api.nvim_create_autocmd("FocusGained", {
	group = shada_au,
	command = "rshada",
})
