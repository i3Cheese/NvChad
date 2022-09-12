local utils = require("core.utils")

local map = utils.map

local cmd = vim.cmd

local M = {}

-- these mappings will only be called during initialization
M.misc = function()
	-- Don't copy the replaced text after pasting in visual mode
	map("v", "p", "p:let @+=@0<CR>")

	-- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
	-- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
	-- empty mode is same as using :map
	-- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
	map({ "n", "x", "o" }, "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
	map({ "n", "x", "o" }, "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
	map("", "<Down>", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
	map("", "<Up>", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })

	-- use ESC to turn off search highlighting
	map("n", "<Esc>", "<CMD>noh <CR>")

	-- center cursor when moving (goto_definition)

	-- yank from current cursor to end of line
	map("n", "Y", "yg$")

	-- easier navigation between windows
	map({ "n", "t" }, "<C-h>", "<C-w>h")
	map({ "n", "t" }, "<C-l>", "<C-w>l")
	map({ "n", "t" }, "<C-k>", "<C-w>k")
	map({ "n", "t" }, "<C-j>", "<C-w>j")

	map("n", "<leader>k", "K", { noremap = true }) -- hover
	map("n", "<leader>j", "J", { noremap = true }) -- join lines

	map("n", "<leader>x", "<CMD>lua require('core.utils').close_buffer() <CR>") -- close  buffer
	map("n", "<C-a>", "<CMD>%y+ <CR>") -- copy whole file content
	map("n", "<leader>t", "<CMD>enew <CR>") -- new buffer
	map("n", "<C-t>b", "<CMD>tabnew <CR>") -- new tabs
	map("n", "<leader>nn", "<CMD>set nu! <CR>")

	map("v", "<C-c>", '"+y')
	map("n", "<C-c>", '"+yy') -- copy curent line in normal mode
	map("v", "<leader>fc", '"hy:%s/<C-r>h//gc<left><left><left>')
	map("v", "<leader>fr", '"hy:%s/<C-r>h//g<left><left><left>')
	map("v", "<leader>ff", '"hy/<C-r>h')
	map("n", "<leader>nr", "<CMD>set rnu! <CR>") -- relative line numbers

	-- terminal mappings --
	-- get out of terminal mode
	map("t", "<C-q>", "<C-\\><C-n>")
	map({ "i", "v", "n", "s" }, "<C-q>", "<Esc>")

	-- Open terminals
	map("n", "<leader>w", "<CMD>execute 'terminal' | let b:term_type = 'wind' | startinsert <CR>")

	map("n", "s", [[:exec "normal i".nr2char(getchar())."\e"<CR>]])
	map("n", "S", [[:exec "normal a".nr2char(getchar())."\e"<CR>]])
	-- terminal mappings end --

	-- Add Packer commands because we are not loading it at startup
	cmd("silent! command PackerClean lua require 'plugins' require('packer').clean()")
	cmd("silent! command PackerCompile lua require 'plugins' require('packer').compile()")
	cmd("silent! command PackerInstall lua require 'plugins' require('packer').install()")
	cmd("silent! command PackerStatus lua require 'plugins' require('packer').status()")
	cmd("silent! command PackerSync lua require 'plugins' require('packer').sync()")
	cmd("silent! command PackerUpdate lua require 'plugins' require('packer').update()")
end

-- below are all plugin related mappings

M.bufferline = function()
	map("n", "<Tab>", "<CMD>BufferLineCycleNext <CR>")
	map("n", "<S-Tab>", "<CMD>BufferLineCyclePrev <CR>")
end

M.comment = function()
	local m = "<leader>/"
	map("n", m, "<Plug>(comment_toggle_linewise_current)")
	map("v", m, "<Plug>(comment_toggle_blockwise_visual)")
end

M.lspconfig = function()
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	map("n", "gD", "<CMD>lua vim.lsp.buf.declaration()<CR>")
	map("n", "gd", "<CMD>lua vim.lsp.buf.definition()<CR>")
	map("n", "gi", "<CMD>lua vim.lsp.buf.implementation()<CR>")
	map("n", "gr", "<CMD>lua vim.lsp.buf.references()<CR>")
	map("n", "K", "<CMD>lua vim.lsp.buf.hover()<CR>")
	map("n", "J", "<CMD>lua vim.lsp.buf.signature_help()<CR>")
	map("n", "gc", "<CMD>lua vim.lsp.buf.type_definition()<CR>")
	map("n", "<leader>r", "<CMD>lua vim.lsp.buf.rename()<CR>")
	map("n", "<leader>ca", "<CMD>lua vim.lsp.buf.code_action()<CR>")
	map("n", "E", "<CMD>lua vim.diagnostic.open_float()<CR>")
	map("n", "[d", "<CMD>lua vim.diagnostic.goto_prev()<CR>")
	map("n", "]d", "<CMD>lua vim.diagnostic.goto_next()<CR>")

	map("n", "<leader>cc", "<CMD>ClangdSwitchSourceHeader<CR>", { noremap = true, silent = true })
	local py_formating_group = vim.api.nvim_create_augroup("PyFormatingGroup", { clear = true })
	vim.api.nvim_create_autocmd("FileType", {
		group = py_formating_group,
		callback = function()
			vim.api.nvim_buf_set_keymap(0, "n", "<Leader>lp", "<CMD>PyrightOrganizeImports<CR>", {})
		end,
	})
	map("n", "<leader>ll", "<CMD>lua vim.lsp.buf.format()<CR>", { noremap = true })
end

M.cmp = function()
	local cmp = require("cmp")
	return cmp.mapping.preset.insert({
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.close(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Insert,
			select = false,
		}),
		["<C-y>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		["<C-I>"] = cmp.mapping(function(fallback)
			if require("snippy").can_expand_or_advance() then
				vim.fn.feedkeys(
					vim.api.nvim_replace_termcodes("<Plug>(snippy-expand-or-advance)", true, true, true),
					""
				)
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif require("snippy").can_expand_or_advance() then
				vim.fn.feedkeys(
					vim.api.nvim_replace_termcodes("<Plug>(snippy-expand-or-advance)", true, true, true),
					""
				)
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif require("snippy").can_jump(-1) then
				vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>(snippy-previous)", true, true, true), "")
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),
	})
end

M.nvimtree = function()
	map("n", "<C-n>", "<CMD>NvimTreeToggle <CR>")
end

local swap_next, swap_prev = (function()
	local swap_objects = {
		p = "@parameter.inner",
		f = "@function.outer",
		e = "@element",
		-- Not ready, but I think it's my fault :)
		-- v = "@variable",
	}

	local n, p = {}, {}
	for key, obj in pairs(swap_objects) do
		n[string.format("<M-Space><M-%s>", key)] = obj
		p[string.format("<M-BS><M-%s>", key)] = obj
	end

	return n, p
end)()
M.treesitter = {
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "<M-w>", -- maps in normal mode to init the node/scope selection
			node_incremental = "<M-w>", -- increment to the upper named parent
			node_decremental = "<M-S-w>", -- decrement to the previous node
			scope_incremental = "<M-e>", -- increment to the upper scope (as defined in locals.scm)
		},
	},
	textobjects = {
		enable = true,
		move = {
			enable = true,
			set_jumps = true,

			goto_next_start = {
				["]p"] = "@parameter.inner",
				["]m"] = "@function.outer",
				["]]"] = "@class.outer",
			},
			goto_next_end = {
				["]M"] = "@function.outer",
				["]["] = "@class.outer",
			},
			goto_previous_start = {
				["[p"] = "@parameter.inner",
				["[m"] = "@function.outer",
				["[["] = "@class.outer",
			},
			goto_previous_end = {
				["[M"] = "@function.outer",
				["[]"] = "@class.outer",
			},
		},

		select = {
			enable = true,
			keymaps = {
				["af"] = "@function.outer",
				["if"] = "@function.inner",

				["ac"] = "@conditional.outer",
				["ic"] = "@conditional.inner",

				["aa"] = "@parameter.outer",
				["ia"] = "@parameter.inner",

				["av"] = "@variable.outer",
				["iv"] = "@variable.inner",
			},
		},

		swap = {
			enable = true,
			swap_next = swap_next,
			swap_previous = swap_prev,
		},
	},
}

M.telescope = function()
	map("n", "<leader>W", "<CMD>Telescope terms <CR>") -- pick a hidden term
	map("n", "<leader>bb", "<CMD>Telescope buffers <CR>")
	map("n", "<leader>ff", "<CMD>Telescope find_files <CR>")
	map("n", "<leader>fa", "<CMD>Telescope find_files follow=true no_ignore=true hidden=true <CR>")
	map("n", "<leader>fgc", "<CMD>Telescope git_commits <CR>")
	map("n", "<leader>fgd", "<CMD>Telescope git_status <CR>")
	map("n", "<leader>lg", "<CMD>Telescope live_grep <CR>")
	map("n", "<leader>fw", "<CMD>Telescope grep_string <CR>")
	map("n", "<leader>fs", "<CMD>Telescope symbols <CR>")
	vim.keymap.set({ "n", "i", "c", "v", "o" }, "<C-s>", "<CMD>Telescope symbols<CR>")
	map(
		"n",
		"<Leader><Space>",
		"<CMD>lua require'plugins.telescope'.project_files()<CR>",
		{ noremap = true, silent = true }
	)
end

M.symbols_outline = function()
	map("n", "<Leader>m", "<CMD>SymbolsOutline<CR>", { silent = true })
end

M.dap = function()
	map("n", "<leader>db", "<CMD>lua require'dap'.toggle_breakpoint()<CR>")
	map("n", "<F8>", "<CMD>lua require'dap'.step_over()<CR>")
	map("n", "<F9>", "<CMD>lua require'dap'.step_into()<CR>")
	map("n", "<F10>", "<CMD>lua require'dap'.step_out()<CR>")
	map("n", "<leader>dr", "<CMD>lua require'dap'.repl.open()<CR>")
	map("n", "<leader>dl", "<CMD>lua require'dap'.run_last()<CR>")
end

M.gfold = function()
	map("n", "<leader>gg", "<CMD>lua require('gfold').pick_repo()<CR>")
end

M.entrypoints = function()
	-- nvimtree
	map("n", "<C-n>", "<CMD>NnnExplorer <CR>")
	map("n", "<leader>e", "<CMD>NnnPicker <CR>")

	-- SymbolsOutline
	map("n", "<Leader>m", "<CMD>SymbolsOutline<CR>", { silent = true })

	-- dap
	map("n", "<F5>", "<CMD>RunDebug<CR>")
end

return M
