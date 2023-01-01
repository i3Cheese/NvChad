local packer = require("plugins.packerInit")

local function cond_f(plugin_name)
	return function()
		return require("core.config").plugins.status[plugin_name]
	end
end
local function disable_f(plugin_name)
	return function()
		return not require("core.config").plugins.do_install[plugin_name]
	end
end

local plugins = {
	{ "nvim-lua/plenary.nvim" },
	{ "lewis6991/impatient.nvim" },
	-- { "nathom/filetype.nvim" },

	{
		"wbthomason/packer.nvim",
		event = "VimEnter",
        commit = "de109156cfa634ce0256ea4b6a7c32f9186e2f10"
	},

	{
		"kyazdani42/nvim-web-devicons",
		config = function()
			require("plugins.configs.icons").setup()
		end,
	},

	{
		"feline-nvim/feline.nvim",
		after = "nvim-web-devicons",
		config = function()
			require("plugins.configs.feline").setup()
		end,
	},
	{
		"j-hui/fidget.nvim",
		after = "nvim-lspconfig",
		config = function()
			require("fidget").setup({})
		end,
	},

	{
		"akinsho/bufferline.nvim",
		disable = false,
		cond = function()
			return require("core.config").plugins.status.bufferline
		end,
		config = function()
			require("plugins.configs.bufferline").setup()
			require("core.mappings").bufferline()
		end,
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		event = "BufRead",
		config = function()
			require("plugins.configs.others").blankline()
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufRead", "BufNewFile" },
		config = function()
			require("plugins.configs.treesitter").setup()
		end,
		run = ":TSUpdate",
        commit = "addc129a",
	},
	{ "nvim-treesitter/nvim-treesitter-textobjects" },
	{ "nvim-treesitter/nvim-treesitter-refactor" },
	{ "nvim-treesitter/nvim-treesitter-context" },

	-- git stuff
	{
		"lewis6991/gitsigns.nvim",
		opt = true,
		config = function()
			require("plugins.configs.others").gitsigns()
		end,
		setup = function()
			require("core.utils").packer_lazy_load("gitsigns.nvim")
		end,
	},

	-- lsp stuff

	{
		"neovim/nvim-lspconfig",
		module = "lspconfig",
		opt = true,
		after = "nvim-lsp-installer",
		setup = function()
			require("core.utils").packer_lazy_load("nvim-lspconfig")
			-- reload the current file so lsp actually starts for it
			vim.defer_fn(function()
				vim.cmd('if &ft == "packer" | echo "" | else | silent! e %')
			end, 0)
		end,
		config = function()
			require("plugins.configs.lspconfig").setup()
		end,
	},

	{
		"williamboman/nvim-lsp-installer",
		config = function()
			-- require('custom.plugins.lspconfig').config_lsp_installer()
		end,
	},

	{
		"ray-x/lsp_signature.nvim",
		after = "nvim-lspconfig",
		config = function()
			require("plugins.configs.others").signature()
		end,
	},

	{
		"jose-elias-alvarez/null-ls.nvim",
		config = function()
			local null_ls = require("null-ls")
			null_ls.setup({
				debug = true,
				sources = {
					null_ls.builtins.formatting.autopep8.with({
						extra_args = { "--ignore=E402" },
					}),
					null_ls.builtins.formatting.brittany,
					-- null_ls.builtins.code_actions.gitsigns,
					-- null_ls.builtins.formatting.prettier,
					null_ls.builtins.formatting.djhtml,
					null_ls.builtins.formatting.gofmt,
					null_ls.builtins.hover.dictionary,
				},
			})
		end,
	},
	{
		"mfussenegger/nvim-dap",
		config = function()
			require("plugins.configs.dap").dap.setup()
			require("core.mappings").dap()
		end,
	},
	{
		"theHamsta/nvim-dap-virtual-text",
		config = function()
			require("nvim-dap-virtual-text").setup({})
		end,
		after = "nvim-dap",
	},
	{
		"rcarriga/nvim-dap-ui",
		requires = { "mfussenegger/nvim-dap" },
		after = "nvim-dap",
		config = function()
			require("plugins.configs.dap").dapui.setup()
		end,
	},
	{
		"nvim-telescope/telescope-dap.nvim",
		requires = { "nvim-dap", "telescope.nvim" },
		after = "nvim-dap",
		config = function()
			require("telescope").load_extension("dap")
			vim.cmd("silent! command Vars lua require'telescope'.extensions.dap.variables{}")
			vim.cmd("silent! command Breakpoints lua require'telescope'.extensions.dap.list_breakpoints{}")
		end,
	},
	{
		"mfussenegger/nvim-dap-python",
		requires = { "nvim-dap" },
		after = "nvim-dap",
		config = function()
			require("dap-python").setup("~/python/venvs/debugpy/bin/python")
			local dap = require("dap")
			table.insert(dap.configurations.python, {
				-- The first three options are required by nvim-dap
				type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
				request = "launch",
				name = "Launch file in venv",

				-- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

				program = "${file}", -- This configuration will launch the current file if used.
				pythonPath = require("core.utils").locate_python_executable(),
			})
		end,
	},

	{
		"danymat/neogen",
		config = function()
			require("neogen").setup({
				snippet_engine = "snippy",
			})
		end,
		cmd = { "Neogen" },
		requires = "nvim-treesitter/nvim-treesitter",
		tag = "*",
		event = "InsertEnter",
	},

	{
		"simrat39/symbols-outline.nvim",
		cmd = { "SymbolsOutline", "SymbolsOutlineOpen" },
		config = function()
			require("core.mappings").symbols_outline()
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		config = function()
			require("plugins.configs.cmp").setup()
		end,
	},
	{
		"dcampos/nvim-snippy",
	},
	{
		"dcampos/cmp-snippy",
		requires = { "nvim-snippy", "nvim-cmp" },
	},
	{
		"honza/vim-snippets",
	},
	{
		"hrsh7th/cmp-nvim-lua",
	},

	{
		"hrsh7th/cmp-nvim-lsp",
		after = "cmp-nvim-lua",
	},

	{
		"hrsh7th/cmp-buffer",
		after = "cmp-nvim-lsp",
	},

	{
		"hrsh7th/cmp-path",
		after = "cmp-buffer",
	},

	-- misc plugins
	{
		"windwp/nvim-autopairs",
		after = "nvim-cmp",
		config = function()
			require("plugins.configs.others").autopairs()
		end,
	},
	{
		"goolord/alpha-nvim",
		config = function()
			require("plugins.configs.alpha").setup()
		end,
	},
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
			require("core.mappings").comment()
		end,
	},
	-- file managing , picker etc
	{
		"luukvbaal/nnn.nvim",
		config = function()
			require("plugins.configs.nnn").setup()
		end,
	},
	-- {
	-- 	"kyazdani42/nvim-tree.lua",
	-- 	cmd = { "NvimTreeToggle", "NvimTreeFocus" },
	-- 	config = function()
	-- 		require("plugins.configs.nvimtree").setup()
	-- 	end,
	-- },

	{
		"nvim-telescope/telescope.nvim",
		config = function()
			require("plugins.configs.telescope").setup()
			require("core.mappings").telescope()
		end,
	},
	{
		"nvim-telescope/telescope-symbols.nvim",
	},
	{
		"ellisonleao/glow.nvim",
		cmd = "Glow",
	},
	{
		"callmekohei/switcher.nvim",
		disable = disable_f("mac_switcher"),
		run = function()
			vim.cmd(
				"py3 from pip._internal.cli.main import main as pipmain; pipmain(['install', 'pyobjc-core', 'pyobjc-framework-Cocoa']);"
			)
			vim.cmd(":UpdateRemotePlugins")
		end,
		setup = function()
			vim.g.switcher_keyboardInputSource = "com.apple.keylayout.ABC"
		end,
		config = function()
			vim.cmd([[ autocmd InsertLeave * :call SwitchEnglish('') ]])
		end,
	},
	{
		"Shatur/neovim-session-manager",
		config = function()
			require("session_manager").setup({
				path_replacer = "__", -- The character to which the path separator will be replaced for session files.
				colon_replacer = "++", -- The character to which the colon symbol will be replaced for session files.
				autoload_mode = require("session_manager.config").AutoloadMode.Disabled, -- Define what to do when Neovim is started without arguments. Possible values: Disabled, CurrentDir, LastSession
				autosave_last_session = true, -- Automatically save last session on exit and on session switch.
				autosave_ignore_not_normal = true, -- Plugin will not save a session when no buffers are opened, or all of them aren't writable or listed.
				autosave_ignore_filetypes = { -- All buffers of these file types will be closed before the session is saved.
					"gitcommit",
					"alpha",
				},
				autosave_only_in_session = false, -- Always autosaves session. If true, only autosaves after a session is active.
				max_path_length = 80, -- Shorten the display path if length exceeds this threshold. Use 0 if don't want to shorten the path at all.
			})
		end,
	},

	{
		"andymass/vim-matchup",
		opt = true,
		setup = function()
			require("core.utils").packer_lazy_load("vim-matchup")
		end,
	},

	{
		"max397574/better-escape.nvim",
		event = "InsertCharPre",
		config = function()
			require("plugins.configs.others").better_escape()
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		after = "nvim-treesitter",
		config = function()
			require("nvim-ts-autotag").setup({
				filetypes = {
					"html",
					"javascript",
					"typescript",
					"javascriptreact",
					"typescriptreact",
					"svelte",
					"vue",
					"tsx",
					"jsx",
					"rescript",
					"xml",
					"php",
					"markdown",
					"glimmer",
					"handlebars",
					"hbs",
					"htmldjango",
				},
				skip_tags = {
					"area",
					"base",
					"br",
					"col",
					"command",
					"embed",
					"hr",
					"img",
					"slot",
					"input",
					"keygen",
					"link",
					"meta",
					"param",
					"source",
					"track",
					"wbr",
					"menuitem",
				},
			})
		end,
	},
	{ -- configuring tabs
		"gpanders/editorconfig.nvim",
	},
	{
		"AckslD/nvim-gfold.lua",
		config = function()
			require("gfold").setup({
				cwd = vim.fn.getenv("HOME") .. "/projects",
				status_symbols = {
					clean = "✔",
					unclean = "✘",
					unpushed = "",
					bare = "",
				},
				picker = {
					format_item = function(repo)
						return string.format(
							"%s %s (%s)",
							require("gfold.settings").status_symbols[repo.status],
							repo.name,
							repo.path
						)
					end,
					on_select = function(repo, idx)
						if repo then
							vim.cmd("cd " .. repo.path)
							vim.cmd("SessionManager load_current_dir_session")
						end
					end,
				},
				status = {
					enable = false,
					update_delay = 5000,
				},
			})
			require("core.mappings").gfold()
		end,
	},
	{
		"stevearc/dressing.nvim",
		config = function()
			require("dressing").setup({
				input = {
					border = "rounded",
				},
			})
		end,
	},
	{
		"glacambre/firenvim",
		run = function()
			vim.fn.eval("firenvim#install(0)")
		end,
		cond = cond_f("firenvim"),
		config = function()
			require("plugins.configs.firenvim").setup()
		end,
	},
	{
		"folke/zen-mode.nvim",
		config = function()
			require("plugins.configs.zen").setup()
		end,
		cmd = { "ZenMode" },
	},
	{
		"alec-gibson/nvim-tetris",
	},
	{
		"tpope/vim-fugitive",
	},
	{
		"tpope/vim-git",
	},
	{
		"folke/todo-comments.nvim",
		requires = "nvim-lua/plenary.nvim",
		config = function()
			require("todo-comments").setup({
			})
		end,
	},
    {
        "eandrju/cellular-automaton.nvim"
    }
}

--label plugins for operational assistance
local plugins_labeled = {}
for _, plugin in ipairs(plugins) do
	plugins_labeled[plugin[1]] = plugin
end
plugins = plugins_labeled

return function()
	packer.startup(function(use)
		for _, v in pairs(plugins) do
			use(v)
		end
	end)
end
