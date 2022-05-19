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
    map("n", "<Esc>", ":noh <CR>")

    -- center cursor when moving (goto_definition)

    -- yank from current cursor to end of line
    map("n", "Y", "yg$")

    -- don't yank text on delete ( dd )
    map({ "n", "v" }, "d", '"_d')

    -- easier navigation between windows
    map("n", "<C-h>", "<C-w>h")
    map("n", "<C-l>", "<C-w>l")
    map("n", "<C-k>", "<C-w>k")
    map("n", "<C-j>", "<C-w>j")

    map("n", "<leader>k", "K", {noremap = true}) -- hover
    map("n", "<leader>j", "J", {noremap = true}) -- join lines

    map("n", "<leader>x", ":lua require('core.utils').close_buffer() <CR>") -- close  buffer
    map("n", "<C-a>", ":%y+ <CR>") -- copy whole file content
    map("n", "<leader>t", ":enew <CR>") -- new buffer
    map("n", "<C-t>b", ":tabnew <CR>") -- new tabs
    map("n", "<leader>nn", ":set nu! <CR>")


    map("v", "<C-c>", '"+y')
    map("n", "<C-c>", '"+yy') -- copy curent line in normal mode
    map("v", "<leader>fc", '"hy:%s/<C-r>h//gc<left><left><left>')
    map("v", "<leader>fr", '"hy:%s/<C-r>h//g<left><left><left>')
    map("v", "<leader>ff", '"hy/<C-r>h')
    map("n", "<leader>nr", ":set rnu! <CR>") -- relative line numbers

    -- terminal mappings --
    -- get out of terminal mode
    map("t", "jk", "<C-\\><C-n>")
    -- pick a hidden term
    map("n", "<leader>W", ":Telescope terms <CR>")
    -- Open terminals
    map("n", "<leader>w", ":execute 'terminal' | let b:term_type = 'wind' | startinsert <CR>")
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
	map("n", "<Tab>", ":BufferLineCycleNext <CR>")
	map("n", "<S-Tab>", ":BufferLineCyclePrev <CR>")
end

M.comment = function()
	local m = "<leader>/"
	map("n", m, ":lua require('Comment.api').toggle_current_linewise()<CR>")
	map("v", m, ":lua require('Comment.api').toggle_linewise_op(vim.fn.visualmode())<CR>")
end

M.lspconfig = function()

	-- See `:help vim.lsp.*` for documentation on any of the below functions
	map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
	map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
	map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
	map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
	map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
	map("n", "J", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
	map("n", "gc", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
	map("n", "<leader>r", "<cmd>lua vim.lsp.buf.rename()<CR>")
	map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
	map("n", "E", "<cmd>lua vim.diagnostic.open_float()<CR>")
	map("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
	map("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>")

	map("n", "<Leader>cc", "<CMD>ClangdSwitchSourceHeader<CR>", { noremap = true, silent = true })
	map("n", "<Leader>ll", "<CMD>lua vim.lsp.buf.formatting()<CR>", { noremap = true })
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
	map("n", "<C-n>", ":NvimTreeToggle <CR>")
end

M.telescope = function()
	map("n", "<leader>fb", ":Telescope buffers <CR>")
	map("n", "<leader>ff", ":Telescope find_files <CR>")
	map("n", "<leader>fa", ":Telescope find_files follow=true no_ignore=true hidden=true <CR>")
	map("n", "<leader>fgc", ":Telescope git_commits <CR>")
	map("n", "<leader>fgd", ":Telescope git_status <CR>")
	map("n", "<leader>lg", ":Telescope live_grep <CR>")
    map("n", "<leader>fw", ":Telescope grep_string <CR>")
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
	map("n", "<leader>b", "<CMD>lua require'dap'.toggle_breakpoint()<CR>")
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
	map("n", "<C-n>", ":NvimTreeToggle <CR>")

	-- SymbolsOutline
	map("n", "<Leader>m", "<CMD>SymbolsOutline<CR>", { silent = true })

	-- dap
	map("n", "<F5>", "<CMD>RunDebug<CR>")
end

return M
