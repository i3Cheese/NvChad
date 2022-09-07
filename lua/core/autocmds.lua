-- vim.cmd [[ autocmd BufEnter * if &buftype != "terminal" | lcd %:p:h | endif ]]

-- Use relative & absolute line numbers in 'n' & 'i' modes respectively
vim.cmd([[ au InsertEnter * set norelativenumber ]])
vim.cmd([[ au InsertLeave * set relativenumber ]])

-- Don't show any numbers inside terminals
vim.cmd([[ au TermOpen term://* setlocal nonumber norelativenumber | setfiletype terminal ]])

local shada_au_group = vim.api.nvim_create_augroup("SHADA", { clear = true })
vim.api.nvim_create_autocmd("FocusLost", {
	group = shada_au_group,
	command = "wshada",
})
vim.api.nvim_create_autocmd("FocusGained", {
	group = shada_au_group,
	command = "rshada",
})

local formating_au_group = vim.api.nvim_create_augroup("FormatingGroup", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = {"*.py", "*.js"},
    group = formating_au_group,
    callback = vim.lsp.buf.formatting
})
