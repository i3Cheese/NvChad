local map = require("core.utils").map
local M = {}


M.telescope = function()
    map("n", "<Leader><Space>", "<CMD>lua require'custom.plugins.telescope'.project_files()<CR>", {noremap = true, silent = true})
end

M.lsp = function()
    map("n", "<Leader>cc", "<CMD>ClangdSwitchSourceHeader<CR>", {noremap = true, silent = true})
    map("n", "<Leader>ll", "<CMD>lua vim.lsp.buf.formatting()<CR>", {noremap = true})
end

M.symbols_outline = function()
    map("n", "<Leader>m", "<CMD>SymbolsOutline<CR>", {silent = true})
end

M.dap = function ()
    map("n", "<F5>", "<CMD>RunDebug<CR>")
    map("n", "<leader>b", "<CMD>lua require'dap'.toggle_breakpoint()<CR>")
    map("n", "<F8>", "<CMD>lua require'dap'.step_over()<CR>")
    map("n", "<F9>", "<CMD>lua require'dap'.step_into()<CR>")
    map("n", "<F10>", "<CMD>lua require'dap'.step_out()<CR>")
    map("n", "<leader>dr", "<CMD>lua require'dap'.repl.open()<CR>")
    map("n", "<leader>dl", "<CMD>lua require'dap'.run_last()<CR>")
end

M.misc = function()
    map("v", "<C-c>", '"+y')
    map("n", "<C-c>", '"+yy') -- copy curent line in normal mode
    map("v", "<leader>fc", "\"hy:%s/<C-r>h//gc<left><left><left>")
    map("v", "<leader>fr", "\"hy:%s/<C-r>h//g<left><left><left>")
    map("v", "<leader>ff", "\"hy/<C-r>h")
end


return M
