local M = {}
local config = {}

config.defaults = {
	command = { "/opt/homebrew/bin/md-to-pdf" },
}

setmetatable(config, { __index = config.defaults })

M.convert = function(file)
    -- local command = vim.deepcopy(config.command)
    -- table.insert(command, file)
    local command = {
        "md-to-pdf",
        file,
    }
	vim.fn.jobstart(command, {
        cwd = vim.fn.getcwd(),
		on_stdout = function(arg1, arg2, arg3)
            print("stdout")
            vim.pretty_print(arg1)
            vim.pretty_print(arg2)
            vim.pretty_print(arg3)
		end,
		on_stderr = function(arg1, arg2, arg3)
            print("stderr")
            vim.pretty_print(arg1)
            vim.pretty_print(arg2)
            vim.pretty_print(arg3)
		end,
		stdout_buffered = false,
	})
end

M.md_to_pdf = function (args)
    vim.pretty_print(args)
    M.convert(args.args)
end

M.setup = function (opts)
    if opts then
        setmetatable(config, { __index = vim.tbl_extend('force', config.defaults, opts) })
    end
    vim.api.nvim_create_user_command(
        "MdToPdf",
        M.md_to_pdf,
        {
            nargs = "?",
            complete = "file"
        }
    )
end

return M
