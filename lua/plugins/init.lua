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

local function no_vscode()
    return not vim.g.vscode
end

local plugins = {
    {
        "nvim-lua/plenary.nvim"
    },
    {
        "lewis6991/impatient.nvim"
    },
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
        cond = no_vscode,
        config = function()
            require("plugins.configs.feline").setup()
        end,
    },
    {
        "j-hui/fidget.nvim",
        after = "nvim-lspconfig",
        cond = no_vscode,
        config = function()
            require("fidget").setup({})
        end,
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        event = "BufRead",
        cond = no_vscode,
        config = function()
            require("plugins.configs.others").blankline()
        end,
    },
    -- {
    --     'rush-rs/tree-sitter-asm',
    --     config = function()
    --         require('nvim-treesitter.parsers').get_parser_configs().asm = {
    --             install_info = {
    --                 url = 'https://github.com/rush-rs/tree-sitter-asm.git',
    --                 files = { 'src/parser.c' },
    --                 branch = 'main',
    --             },
    --         }
    --     end
    -- },

    {
        "nvim-treesitter/nvim-treesitter",
        cond = no_vscode,
        config = function()
            require("plugins.configs.treesitter").setup()
        end,
        run = ":TSUpdate",
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        cond = no_vscode,
        after = "nvim-treesitter",
    },
    {
        "nvim-treesitter/nvim-treesitter-refactor",
        cond = no_vscode,
        after = "nvim-treesitter",
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        cond = no_vscode,
        after = "nvim-treesitter",
    },

    -- git stuff
    {
        "lewis6991/gitsigns.nvim",
        opt = true,
        cond = no_vscode,
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
         -- cond = no_vscode,
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
        "github/copilot.vim",
         -- cond = no_vscode,
        setup = function()
            require("core.mappings").copilot()
        end
    },

    -- {
    -- 	"ray-x/lsp_signature.nvim",
    -- 	after = "nvim-lspconfig",
    -- 	config = function()
    -- 		require("plugins.configs.others").signature()
    -- 	end,
    -- },

    {
        "jose-elias-alvarez/null-ls.nvim",
         -- cond = no_vscode,
        config = function()
            require("plugins.configs.lspconfig").setup_null_ls()
        end,
    },
    -- {
    --     "mfussenegger/nvim-dap",
    --     config = function()
    --         require("plugins.configs.dap").dap.setup()
    --         require("core.mappings").dap()
    --     end,
    -- },
    -- {
    --     "theHamsta/nvim-dap-virtual-text",
    --     config = function()
    --         require("nvim-dap-virtual-text").setup({})
    --     end,
    --     after = "nvim-dap",
    -- },
    -- {
    --     "rcarriga/nvim-dap-ui",
    --     requires = { "mfussenegger/nvim-dap" },
    --     after = "nvim-dap",
    --     config = function()
    --         require("plugins.configs.dap").dapui.setup()
    --     end,
    -- },
    -- {
    --     "ldelossa/nvim-dap-projects",
    --     config = function()
    --         require('nvim-dap-projects').search_project_config()
    --     end
    -- },
    -- {
    --     "nvim-telescope/telescope-dap.nvim",
    --     requires = { "nvim-dap", "telescope.nvim" },
    --     after = "nvim-dap",
    --     config = function()
    --         require("telescope").load_extension("dap")
    --         vim.cmd("silent! command Vars lua require'telescope'.extensions.dap.variables{}")
    --         vim.cmd("silent! command Breakpoints lua require'telescope'.extensions.dap.list_breakpoints{}")
    --     end,
    -- },
    {
        "simrat39/rust-tools.nvim",
         -- cond = no_vscode,
        config = function()
            local rt = require("rust-tools")
            rt.setup({
            })
        end
    },
    {
        'saecki/crates.nvim',
         -- cond = no_vscode,
        tag = 'stable',
        requires = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('crates').setup()
        end,
    },
    -- {
    --     "mfussenegger/nvim-dap-python",
    --     requires = { "nvim-dap" },
    --     after = "nvim-dap",
    --     config = function()
    --         require("dap-python").setup("~/python/venvs/debugpy/bin/python")
    --         local dap = require("dap")
    --         table.insert(dap.configurations.python, {
    --             -- The first three options are required by nvim-dap
    --             type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
    --             request = "launch",
    --             name = "Launch file in venv",
    --
    --             -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options
    --
    --             program = "${file}", -- This configuration will launch the current file if used.
    --             pythonPath = require("core.utils").locate_python_executable(),
    --         })
    --     end,
    -- },
    --
    {
        "danymat/neogen",
         -- cond = no_vscode,
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
    --
    -- {
    --     "simrat39/symbols-outline.nvim",
    --     cmd = { "SymbolsOutline", "SymbolsOutlineOpen" },
    --     config = function()
    --         require("core.mappings").symbols_outline()
    --     end,
    -- },
    {
        "hrsh7th/nvim-cmp",
         -- cond = no_vscode,
        config = function()
            require("plugins.configs.cmp").setup()
        end,
    },
    {
        "dcampos/nvim-snippy",
         -- cond = no_vscode,
    },
    {
        "dcampos/cmp-snippy",
         -- cond = no_vscode,
        requires = { "nvim-snippy", "nvim-cmp" },
    },
    {
        "honza/vim-snippets",
         -- cond = no_vscode,
    },
    {
        "hrsh7th/cmp-nvim-lua",
         -- cond = no_vscode,
    },

    {
        "hrsh7th/cmp-nvim-lsp",
        after = "cmp-nvim-lua",
         -- cond = no_vscode,
    },

    {
        "hrsh7th/cmp-buffer",
        after = "cmp-nvim-lsp",
         -- cond = no_vscode,
    },

    {
        "hrsh7th/cmp-path",
        after = "cmp-buffer",
         -- cond = no_vscode,
    },

    -- misc plugins
    -- {
    --     "windwp/nvim-autopairs",
    --     after = "nvim-cmp",
    --     config = function()
    --         require("plugins.configs.others").autopairs()
    --     end,
    -- },
    {
        "windwp/nvim-ts-autotag",
        after = "nvim-treesitter",
         -- cond = no_vscode,
        config = function()
            require('nvim-ts-autotag').setup({
                opts = {
                    -- Defaults
                    enable_close = true,         -- Auto close tags
                    enable_rename = true,        -- Auto rename pairs of tags
                    enable_close_on_slash = true -- Auto close on trailing </
                },
                -- Also override individual filetype configs, these take priority.
                -- Empty by default, useful if one of the "opts" global settings
                -- doesn't work well in a specific filetype
                per_filetype = {
                    -- ["html"] = {
                    --     enable_close = false
                    -- }
                }
            })
        end
    },
    {
        "goolord/alpha-nvim",
         -- cond = no_vscode,
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
         -- cond = no_vscode,
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
         -- cond = no_vscode,
        cmd = "Glow",
        config = function()
            require("glow").setup()
        end,
    },
    {
        "Shatur/neovim-session-manager",
        commit = "a0b9d25154be573bc0f99877afb3f57cf881cce7",
         -- cond = no_vscode,
        config = function()
            require("session_manager").setup({
                path_replacer = "__",                                                    -- The character to which the path separator will be replaced for session files.
                colon_replacer = "++",                                                   -- The character to which the colon symbol will be replaced for session files.
                autoload_mode = require("session_manager.config").AutoloadMode.Disabled, -- Define what to do when Neovim is started without arguments. Possible values: Disabled, CurrentDir, LastSession
                autosave_last_session = true,                                            -- Automatically save last session on exit and on session switch.
                autosave_ignore_not_normal = true,                                       -- Plugin will not save a session when no buffers are opened, or all of them aren't writable or listed.
                autosave_ignore_filetypes = {                                            -- All buffers of these file types will be closed before the session is saved.
                    "gitcommit",
                    "gitrebase",
                    "alpha",
                },
                autosave_only_in_session = false, -- Always autosaves session. If true, only autosaves after a session is active.
                max_path_length = 80,             -- Shorten the display path if length exceeds this threshold. Use 0 if don't want to shorten the path at all.
            })
        end,
    },

    -- {
    --     "andymass/vim-matchup",
    --     opt = true,
    --     setup = function()
    --         require("core.utils").packer_lazy_load("vim-matchup")
    --     end,
    -- },

    {
        "max397574/better-escape.nvim",
         -- cond = no_vscode,
        event = "InsertCharPre",
        config = function()
            require("plugins.configs.others").better_escape()
        end,
    },
    { -- configuring tabs
        "gpanders/editorconfig.nvim",
         -- cond = no_vscode,
    },
    {
        "AckslD/nvim-gfold.lua",
         -- cond = no_vscode,
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
                select = {
                    border = "rounded",

                },
            })
        end,
    },
    -- {
    --     "glacambre/firenvim",
    --     run = function()
    --         vim.fn.eval("firenvim#install(0)")
    --     end,
    --      -- cond = cond_f("firenvim"),
    --     config = function()
    --         require("plugins.configs.firenvim").setup()
    --     end,
    -- },
    {
        "tpope/vim-fugitive",
         -- cond = no_vscode,
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
        "eandrju/cellular-automaton.nvim",
         -- cond = no_vscode,
    },
    -- {
    --     "dbakker/vim-projectroot",
    --     config = function()
    --         vim.g.rootmarkers = { ".git" }
    --         vim.api.nvim_create_autocmd("BufEnter", {
    --             pattern = "*",
    --             callback = function()
    --                 if vim.fn.argc() > 0 then
    --                     pcall(vim.cmd, ":ProjectRootCD")
    --                 end
    --             end,
    --         })
    --         -- vim.cmd(":ProjectRootCD")
    --     end,
    -- },
    -- {
    --     "MrcJkb/haskell-tools.nvim",
    --     requires = {
    --         'nvim-lua/plenary.nvim',
    --         'nvim-telescope/telescope.nvim',
    --     },
    --     branch = '1.x.x',
    -- },
    {
        "brenoprata10/nvim-highlight-colors",
        config = function()
            require("nvim-highlight-colors").setup({
                render = 'background', -- or 'foreground' or 'first_column'
                enable_named_colors = true,
            })
        end,
    },
    {
        "ThePrimeagen/harpoon",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            require("plugins.configs.harpoon").setup()
        end,
    },
    { 'kaarmu/typst.vim', ft = { 'typst' } },
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
