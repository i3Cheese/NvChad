local M = {}

M.dap = {
    config = function()
        local dap = require('dap')
        vim.cmd "silent! command RunDebug lua require'dap'.continue()"
        vim.cmd "silent! command StopDebug lua require'dap'.disconnect()"

        require('custom.mapping').dap()

        dap.adapters.lldb = {
            type = 'executable',
            command = 'lldb-vscode',
            name = 'lldb',
            -- enrich_config = function(config, on_config)
            --     if (config.cmd ~= nil) then
            --         vim.cmd(config.cmd)
            --     end
            --     on_config(config)
            -- end
        }
        dap.configurations.cpp = {
            {
                name = "Build and launch",
                type = "lldb",
                request = "launch",
                program = '${fileDirname}/${fileBasenameNoExtension}',
                cwd = '${fileDirname}',
                stopOnEntry = false,
                cmd = '!compcpp ${file}',
                args = {},
                runInTerminal = false,
            },
            {
                name = "Launch",
                type = "lldb",
                request = "launch",
                program = function()
                    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                end,
                cwd = '${workspaceFolder}',
                stopOnEntry = false,
                args = {},
            },
            {
                -- If you get an "Operation not permitted" error using this, try disabling YAMA:
                --  echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
                name = "Attach to process",
                type = 'lldb',  -- Adjust this to match your adapter name (`dap.adapters.<name>`)
                request = 'attach',
                pid = require('dap.utils').pick_process,
                args = {},
            },
        }
    end,
}

M.dapui = {
    config = function()
        local dap, dapui = require("dap"), require("dapui")
        dapui.setup({
            icons = { expanded = "▾", collapsed = "▸" },
            mappings = {
                -- Use a table to apply multiple mappings
                expand = { "<CR>", "<2-LeftMouse>" },
                open = "o",
                remove = "d",
                edit = "e",
                repl = "r",
            },
            sidebar = {
                -- You can change the order of elements in the sidebar
                elements = {
                    -- Provide as ID strings or tables with "id" and "size" keys
                    {
                        id = "scopes",
                        size = 0.25, -- Can be float or integer > 1
                    },
                    { id = "breakpoints", size = 0.25 },
                    { id = "stacks", size = 0.25 },
                    { id = "watches", size = 00.25 },
                  },
                  size = 40,
                  position = "left", -- Can be "left", "right", "top", "bottom"
            },
            tray = {
                elements = { "repl" },
                size = 10,
                position = "bottom", -- Can be "left", "right", "top", "bottom"
            },
            floating = {
                max_height = nil, -- These can be integers or a float between 0 and 1.
                max_width = nil, -- Floats will be treated as percentage of your screen.
                border = "single", -- Border style. Can be "single", "double" or "rounded"
                mappings = {
                  close = { "q", "<Esc>" },
                },
            },
            windows = { indent = 1 },
        })
        vim.cmd "silent! command StopDebug :lua require'dap'.disconnect(); require'dapui'.close()"
        dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
        end
        dap.listeners.after.event_terminated["dapui_config"] = function(session, body)
            dapui.close()
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
        end
    end,
}

return M
