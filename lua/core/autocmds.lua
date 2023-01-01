-- vim.cmd [[ autocmd BufEnter * if &buftype != "terminal" | lcd %:p:h | endif ]]

-- Use relative & absolute line numbers in 'n' & 'i' modes respectively
vim.cmd([[ au InsertEnter * set norelativenumber ]])
vim.cmd([[ au InsertLeave * set relativenumber ]])

-- Don't show any numbers inside terminals
vim.cmd([[ au TermOpen term://* setlocal nonumber norelativenumber | setfiletype terminal ]])

local shada_au_group = vim.api.nvim_create_augroup("SHADA", { clear = true })
local is_shada_enable = false
vim.api.nvim_create_autocmd("FocusLost", {
    group = shada_au_group,
    callback = function ()
        if is_shada_enable then
            vim.cmd("wshada")
        end
    end,
})
vim.api.nvim_create_autocmd("FocusGained", {
    group = shada_au_group,
    callback = function ()
        if is_shada_enable then
            vim.cmd("rshada")
        end
    end,
})
vim.api.nvim_create_user_command("EnableShada", function ()
    is_shada_enable = true
end, {})
vim.api.nvim_create_user_command("DisableShada", function ()
    is_shada_enable = true
end, {})

local formating_au_group = vim.api.nvim_create_augroup("FormatingGroup", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.py", "*.js" },
    group = formating_au_group,
    callback = vim.lsp.buf.format
})

local do_cpp_formating = false

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.cpp", "*.h" },
    group = formating_au_group,
    callback = function()
        if do_cpp_formating then
            vim.lsp.buf.format()
        end
    end,
})

local function enable_cpp_autoformat()
    vim.loop.fs_access("./.clang-format", "R", function(err, permission)
        _ = err
        do_cpp_formating = permission
    end)
end

vim.api.nvim_create_autocmd("DirChanged", {
    group = formating_au_group,
    callback = enable_cpp_autoformat,
})

enable_cpp_autoformat()

local filetypes_group = vim.api.nvim_create_augroup("FilytypesGroup", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "typescriptreact", "typescript", "javascript", "javascriptreact" },
    group = filetypes_group,
    callback = function ()
        vim.api.nvim_buf_set_option(0, 'shiftwidth', 2)
    end
})
