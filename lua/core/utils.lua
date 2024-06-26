local M = {}

M.close_buffer = function(force)
	-- This is a modification of a NeoVim plugin from
	-- Author: ojroques - Olivier Roques
	-- Src: https://github.com/ojroques/nvim-bufdel
	-- (Author has okayed copy-paste)

	-- Options
	local opts = {
		next = "alternate", -- how to retrieve the next buffer
		quit = false, -- exit when last buffer is deleted
		--TODO make this a chadrc flag/option
	}

	-- ----------------
	-- Helper functions
	-- ----------------

	-- Switch to buffer 'buf' on each window from list 'windows'
	local function switch_buffer(windows, buf)
		local cur_win = vim.fn.winnr()
		for _, winid in ipairs(windows) do
			winid = tonumber(winid) or 0
			vim.cmd(string.format("%d wincmd w", vim.fn.win_id2win(winid)))
			vim.cmd(string.format("buffer %d", buf))
		end
		vim.cmd(string.format("%d wincmd w", cur_win)) -- return to original window
	end

	-- Select the first buffer with a number greater than given buffer
	local function get_next_buf(buf)
		local next = vim.fn.bufnr("#")
		if opts.next == "alternate" and vim.fn.buflisted(next) == 1 then
			return next
		end
		for i = 0, vim.fn.bufnr("$") - 1 do
			next = (buf + i) % vim.fn.bufnr("$") + 1 -- will loop back to 1
			if vim.fn.buflisted(next) == 1 then
				return next
			end
		end
	end

	-- ----------------
	-- End helper functions
	-- ----------------

	local buf = vim.fn.bufnr()
	if vim.fn.buflisted(buf) == 0 then -- exit if buffer number is invalid
		vim.cmd("close")
		return
	end

	if #vim.fn.getbufinfo({ buflisted = 1 }) < 2 then
		if opts.quit then
			-- exit when there is only one buffer left
			if force then
				vim.cmd("qall!")
			else
				vim.cmd("confirm qall")
			end
			return
		end

		local chad_term, _ = pcall(function()
			return vim.api.nvim_buf_get_var(buf, "term_type")
		end)

		if chad_term then
			-- Must be a window type
			vim.cmd(string.format("setlocal nobl", buf))
			vim.cmd("enew")
			return
		end
		-- don't exit and create a new empty buffer
		vim.cmd("enew")
		vim.cmd("bp")
	end

	local next_buf = get_next_buf(buf)
	local windows = vim.fn.getbufinfo(buf)[1].windows

	-- force deletion of terminal buffers to avoid the prompt
	if force or vim.fn.getbufvar(buf, "&buftype") == "terminal" then
        switch_buffer(windows, next_buf)
        vim.cmd(string.format("bd! %d", buf))
	else
		switch_buffer(windows, next_buf)
		vim.cmd(string.format("silent! confirm bd %d", buf))
	end
	-- revert buffer switches if user has canceled deletion
	if vim.fn.buflisted(buf) == 1 then
		switch_buffer(windows, buf)
	end
end

M.load_config = function()
	local conf = require("core.config")
	return conf
end

M.create_command = function (name, command, opts)
    vim.api.nvim_create_user_command(name, command, opts)
end

M.map = function(mode, keys, command, opt)
	local options = { noremap = true, silent = true }
	if opt then
		options = vim.tbl_extend("force", options, opt)
	end

	-- all valid modes allowed for mappings
	-- :h map-modes
	local valid_modes = {
		[""] = true,
		["n"] = true,
		["v"] = true,
		["s"] = true,
		["x"] = true,
		["o"] = true,
		["!"] = true,
		["i"] = true,
		["l"] = true,
		["c"] = true,
		["t"] = true,
	}

	-- helper function for M.map
	-- can gives multiple modes and keys
	local function map_wrapper(sub_mode, lhs, rhs, sub_options)
		if type(lhs) == "table" then
			for _, key in ipairs(lhs) do
				map_wrapper(sub_mode, key, rhs, sub_options)
			end
		else
			if type(sub_mode) == "table" then
				for _, m in ipairs(sub_mode) do
					map_wrapper(m, lhs, rhs, sub_options)
				end
			else
				if valid_modes[sub_mode] and lhs and rhs then
					vim.api.nvim_set_keymap(sub_mode, lhs, rhs, sub_options)
				else
					sub_mode, lhs, rhs = sub_mode or "", lhs or "", rhs or ""
					print(
						"Cannot set mapping [ mode = '"
							.. sub_mode
							.. "' | key = '"
							.. lhs
							.. "' | cmd = '"
							.. rhs
							.. "' ]"
					)
				end
			end
		end
	end

	map_wrapper(mode, keys, command, options)
end

-- load plugin after entering vim ui
M.packer_lazy_load = function(plugin, timer)
	if plugin then
		timer = timer or 0
		vim.defer_fn(function()
			require("packer").loader(plugin)
		end, timer)
	end
end

M.locate_python_venv = function(cwd)
	if cwd == nil then
		cwd = vim.fn.getcwd()
	end
	if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
		return cwd .. "/venv/"
	elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
		return cwd .. "/.venv/"
	end
	return nil
end

M.locate_python_executable = function(cwd)
	local venv = M.locate_python_venv(cwd)
	if venv == nil then
		return "python3"
	else
		return venv .. "bin/python"
	end
end


M.is_unsaved_buffers_exist = function ()
  local buffers = vim.fn.getbufinfo({bufmodified = 1})
  for i, buffer in ipairs(buffers) do
      if buffer.changed == 1 and buffer.name ~= "" then
          return true
      end
  end
  return false
end

return M
