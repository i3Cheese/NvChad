local M = {}
M.locate_python_venv = function()
    local cwd = vim.fn.getcwd()
    if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
        return cwd .. '/venv/'
    elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
        return cwd .. '/.venv/'
    end
    return nil
end

M.locate_python_executable = function ()
    local venv = M.locate_python_venv()
    if venv == nil then
        return '/usr/bin/python3'
    else
        return venv .. 'bin/python'
    end
end


return M
