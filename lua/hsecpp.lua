local Job = require 'plenary.job'

local M = {}

M.get_name = function(bufnr)
    local path = vim.api.nvim_buf_get_name(bufnr)
    local name = string.match(path, "/tasks/[%a%d_-]+")
    name = string.gsub(name, "/tasks/", "")
    return name
end

M.window_num = -1

M.create_tmp_buf = function()
    if not vim.api.nvim_win_is_valid(M.window_num) then
        vim.cmd('split')
        M.window_num = vim.api.nvim_get_current_win()
    end
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(M.window_num, buf)

    return buf
end

M.test = function(name, callback)
    local buf = M.create_tmp_buf()

    local append_data = function(_, data)
        vim.api.nvim_buf_set_lines(buf, -1, -1, false, data)
    end
    -- vim.fn.termopen("cd build && make && test_"..name)

    P("Testing task " .. name)
    local function run_test()
        vim.fn.jobstart("./build/test_" .. name, {
            stdout_buffered = true,
            stderr_beffered = true,
            on_stdout = append_data,
            on_stderr = append_data,
            on_exit = function(j, return_val)
                P(j)
                P(return_val)
                if return_val == 0 then
                    if callback then
                        callback()
                    end
                end
            end,
        })
    end

    vim.fn.jobstart("make", {
        cwd = "./build/tasks/" .. name,
        stdout_buffered = true,
        stderr_beffered = true,
        on_stdout = append_data,
        on_stderr = append_data,
        on_exit = function(j, return_val)
            if return_val == 0 then
                run_test()
            end
        end,
    })
end

M.create_branch = function(name)
    vim.cmd(":G checkout main")
    vim.cmd(":G pull --ff-only")
    vim.cmd(":G checkout -b submits/" .. name)
end

M.go_to_branch = function(name)
    vim.cmd(":G checkout submits/" .. name)
end

M.push = function(name)
    vim.cmd(":G commit tasks/" .. name .. " -m solution")
    vim.cmd(":G push --set-upstream origin submits/" .. name)
end

M.do_create_branch = function()
    M.create_branch(M.get_name(0))
end

M.do_go_to_branch = function()
    M.go_to_branch(M.get_name(0))
end

M.do_push = function()
    local name = M.get_name(0)
    M.test(name, function() M.push(name) end)
end

M.do_test_cur_buf = function()
    local name = M.get_name(0);
    M.test(name);
end

M.setup = function()
    vim.api.nvim_create_user_command("HseTest", M.do_test_cur_buf, {})
    vim.api.nvim_create_user_command("HseCreateBranch", M.do_create_branch, {})
    vim.api.nvim_create_user_command("HseGoToBranch", M.do_go_to_branch, {})
    vim.api.nvim_create_user_command("HsePush", M.do_push, {})
end

return M
