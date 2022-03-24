local plugin_settings = require("core.utils").load_config().plugins
local present, packer = pcall(require, plugin_settings.options.packer.init_file)

if not present then
    return false
end

local override_req = require("core.utils").override_req

local plugins = {
    { "NvChad/extensions" },
    { "nvim-lua/plenary.nvim" },
    { "lewis6991/impatient.nvim" },
    { "nathom/filetype.nvim" },

    {
        "wbthomason/packer.nvim",
        event = "VimEnter",
    },

    {
        "NvChad/nvim-base16.lua",
        after = "packer.nvim",
        config = function()
            require("colors").init()
        end,
    },

    {
        "kyazdani42/nvim-web-devicons",
        after = "nvim-base16.lua",
        config = override_req("nvim_web_devicons", "plugins.configs.icons", "setup"),
    },

    {
        "feline-nvim/feline.nvim",
        disable = not plugin_settings.status.feline,
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
        -- disable = true,
    },

    {
        "akinsho/bufferline.nvim",
        disable = not plugin_settings.status.bufferline,
        after = "nvim-web-devicons",
        config = override_req("bufferline", "plugins.configs.bufferline", "setup"),
        setup = function()
            require("core.mappings").bufferline()
        end,
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        disable = not plugin_settings.status.blankline,
        event = "BufRead",
        config = override_req("indent_blankline", "plugins.configs.others", "blankline"),
    },

    {
        "NvChad/nvim-colorizer.lua",
        disable = not plugin_settings.status.colorizer,
        event = "BufRead",
        config = override_req("nvim_colorizer", "plugins.configs.others", "colorizer"),
    },

    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufRead", "BufNewFile" },
        config = override_req("nvim_treesitter", "plugins.configs.treesitter", "setup"),
        run = ":TSUpdate",
    },

    -- git stuff
    {
        "lewis6991/gitsigns.nvim",
        disable = not plugin_settings.status.gitsigns,
        opt = true,
        config = override_req("gitsigns", "plugins.configs.others", "gitsigns"),
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
        disable = not plugin_settings.status.lspsignature,
        after = "nvim-lspconfig",
        config = override_req("signature", "plugins.configs.others", "signature"),
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
                    null_ls.builtins.code_actions.gitsigns,
                    null_ls.builtins.formatting.stylua,
                },
            })
        end,
    },
    {
        "mfussenegger/nvim-dap",
        config = function()
            require("plugins.configs.dap").dap.config()
            require("core.mappings").dap()
        end,
        disabled = not plugin_settings.status.dap,
    },
    {
        "theHamsta/nvim-dap-virtual-text",
        config = function()
            require("nvim-dap-virtual-text").setup()
        end,
        after = "nvim-dap",
    },
    {
        "rcarriga/nvim-dap-ui",
        requires = { "mfussenegger/nvim-dap" },
        after = "nvim-dap",
        config = function()
            require("plugins.configs.dap").dapui.config()
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
            require("neogen").setup({})
        end,
        requires = "nvim-treesitter/nvim-treesitter",
        tag = "*",
        event = "InsertEnter",
    },

    {
        "simrat39/symbols-outline.nvim",
        event = "BufRead",
        config = function()
            require("core.mappings").symbols_outline()
        end,
    },
    -- load luasnips + cmp related in insert mode only

    {
        "rafamadriz/friendly-snippets",
        module = "cmp_nvim_lsp",
        disable = not plugin_settings.status.cmp,
        event = "InsertEnter",
    },

    {
        "hrsh7th/nvim-cmp",
        disable = not plugin_settings.status.cmp,
        after = "friendly-snippets",
        config = override_req("nvim_cmp", "plugins.configs.cmp", "setup"),
    },

    {
        "L3MON4D3/LuaSnip",
        disable = not plugin_settings.status.cmp,
        wants = "friendly-snippets",
        after = "nvim-cmp",
        config = override_req("luasnip", "plugins.configs.others", "luasnip"),
    },

    {
        "saadparwaiz1/cmp_luasnip",
        disable = not plugin_settings.status.cmp,
        after = plugin_settings.options.cmp.lazy_load and "LuaSnip",
    },

    {
        "hrsh7th/cmp-nvim-lua",
        disable = not plugin_settings.status.cmp,
        after = "cmp_luasnip",
    },

    {
        "hrsh7th/cmp-nvim-lsp",
        disable = not plugin_settings.status.cmp,
        after = "cmp-nvim-lua",
    },

    {
        "hrsh7th/cmp-buffer",
        disable = not plugin_settings.status.cmp,
        after = "cmp-nvim-lsp",
    },

    {
        "hrsh7th/cmp-path",
        disable = not plugin_settings.status.cmp,
        after = "cmp-buffer",
    },

    -- misc plugins
    {
        "windwp/nvim-autopairs",
        disable = not plugin_settings.status.autopairs,
        after = plugin_settings.options.autopairs.loadAfter,
        config = override_req("nvim_autopairs", "plugins.configs.others", "autopairs"),
    },

    {
        disable = not plugin_settings.status.alpha,
        "goolord/alpha-nvim",
        config = override_req("alpha", "plugins.configs.alpha"),
    },

    {
        "numToStr/Comment.nvim",
        disable = not plugin_settings.status.comment,
        module = "Comment",
        keys = { "gcc" },
        config = override_req("nvim_comment", "plugins.configs.others", "comment"),
        setup = function()
            require("core.mappings").comment()
        end,
    },

    -- file managing , picker etc
    {
        "kyazdani42/nvim-tree.lua",
        disable = not plugin_settings.status.nvimtree,
        -- only set "after" if lazy load is disabled and vice versa for "cmd"
        after = not plugin_settings.options.nvimtree.lazy_load and "nvim-web-devicons",
        cmd = plugin_settings.options.nvimtree.lazy_load and { "NvimTreeToggle", "NvimTreeFocus" },
        config = function()
            require("plugins.configs.nvimtree").setup()
            require("core.mappings").nvimtree()
        end,
    },

    {
        "nvim-telescope/telescope.nvim",
        module = "telescope",
        cmd = "Telescope",
        config = function()
            require("plugins.configs.telescope").setup()
            require("core.mappings").telescope()
        end,
    },
    {
        "ellisonleao/glow.nvim",
        cmd = "Glow",
    },
    {
        "callmekohei/switcher.nvim",
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
                autoload_mode = require("session_manager.config").AutoloadMode.CurrentDir, -- Define what to do when Neovim is started without arguments. Possible values: Disabled, CurrentDir, LastSession
                autosave_last_session = true, -- Automatically save last session on exit and on session switch.
                autosave_ignore_not_normal = true, -- Plugin will not save a session when no buffers are opened, or all of them aren't writable or listed.
                autosave_ignore_filetypes = { -- All buffers of these file types will be closed before the session is saved.
                    "gitcommit",
                },
                autosave_only_in_session = false, -- Always autosaves session. If true, only autosaves after a session is active.
                max_path_length = 80, -- Shorten the display path if length exceeds this threshold. Use 0 if don't want to shorten the path at all.
            })
        end,
    },

    {
        "andymass/vim-matchup",
        disable = not plugin_settings.status.vim_matchup,
        opt = true,
        setup = function()
            require("core.utils").packer_lazy_load("vim-matchup")
        end,
    },

    {
        "max397574/better-escape.nvim",
        disable = not plugin_settings.status.better_escape,
        event = "InsertCharPre",
        config = override_req("better_escape", "plugins.configs.others", "better_escape"),
    },
}

--label plugins for operational assistance
plugins = require("core.utils").label_plugins(plugins)

return packer.startup(function(use)
    for _, v in pairs(plugins) do
        use(v)
    end
end)
