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
	require("nvim-treesitter").setup({
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
    require'nvim-treesitter'.install {
        "lua",
        "vim",
        "python",
        "cpp",
        "yaml",
        "json",
        "html",
        "javascript",
    };
end

return M
