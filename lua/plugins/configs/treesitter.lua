local M = {}

local disable_on_large_files = function(lang, buf)
    local max_filesize = 100 * 1024 -- 100 KB
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
    if ok and stats and stats.size > max_filesize then
        return true
    end
end

M.setup = function()
	local mapping = require("core.mappings").treesitter

	require("nvim-treesitter.configs").setup({
		-- ensure_installed = {
		-- 	"lua",
		-- 	"vim",
		-- 	"python",
		-- 	"cpp",
		-- 	"yaml",
		-- 	"json",
		-- 	"html",
		-- 	"javascript",
		-- },
		highlight = {
			enable = true,
			use_languagetree = true,
            disable = disable_on_large_files,
		},
		refactor = {
			highlight_definitions = { 
                enable = true,
                disable = function(lang, buf)
                    local max_filesize = 100 * 1024 -- 100 KB
                    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                    if ok and stats and stats.size > max_filesize then
                        return true
                    end
                end,
            },
		},

		incremental_selection = mapping.incremental_selection,
		--
		context_commentstring = {
			enable = true,

			-- With Comment.nvim, we don't need to run this on the autocmd.
			-- Only run it in pre-hook
			enable_autocmd = false,

			config = {
				c = "// %s",
				lua = "-- %s",
			},
		},
		--
		textobjects = mapping.textobjects,
        rainbow = {
            enable = true,
            -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
            extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
            max_file_lines = nil, -- Do not enable for files with more than n lines, int
            -- colors = {}, -- table of hex strings
            -- termcolors = {} -- table of colour name strings
          },
	})
	require("treesitter-context").setup({
		enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
		max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
		patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
			-- For all filetypes
			-- Note that setting an entry here replaces all other patterns for this entry.
			-- By setting the 'default' entry below, you can control which nodes you want to
			-- appear in the context window.
			default = {
				"class",
				"function",
				"method",
				'for', -- These won't appear in the context
				'while',
				-- 'if',
				-- 'switch',
				-- 'case',
			},
			-- Example for a specific filetype.
			-- If a pattern is missing, *open a PR* so everyone can benefit.
			--   rust = {
			--       'impl_item',
			--   },
		},
		exact_patterns = {
			-- Example for a specific filetype with Lua patterns
			-- Treat patterns.rust as a Lua pattern (i.e "^impl_item$" will
			-- exactly match "impl_item" only)
			-- rust = true,
		},
		zindex = 20, -- The Z-index of the context window
	})
end

return M
