local map = require("core.utils").map

local mapping = require('custom.mapping')

local settings = {
    status = {
        dap = true,
    },
}

return {
    {
        "ellisonleao/glow.nvim",
        cmd = "Glow"
    },
    {
        "j-hui/fidget.nvim",
        after = "nvim-lspconfig",
        config = function()
            require('fidget').setup({})
        end,
        -- disable = true,
    },
    {
        'callmekohei/switcher.nvim',
        run = function()
            vim.cmd "py3 from pip._internal.cli.main import main as pipmain; pipmain(['install', 'pyobjc-core', 'pyobjc-framework-Cocoa']);"
            vim.cmd ":UpdateRemotePlugins"
        end,
        setup = function()
            vim.g.switcher_keyboardInputSource = "com.apple.keylayout.ABC"
        end,
        config = function()
            vim.cmd [[ autocmd InsertLeave * :call SwitchEnglish('') ]]
        end,
    },
    {
        'jose-elias-alvarez/null-ls.nvim',
        config = function()
            local null_ls = require('null-ls')
            null_ls.setup({
                debug = true,
                sources = {
                    null_ls.builtins.formatting.autopep8.with({
                        extra_args = {'--ignore=E402'}
                    }),
                    null_ls.builtins.formatting.brittany,
                    null_ls.builtins.code_actions.gitsigns,
                    null_ls.builtins.formatting.stylua,
                },
            })
        end,
    },
    {
        "danymat/neogen",
        config = function()
            require('neogen').setup {}
        end,
        requires = "nvim-treesitter/nvim-treesitter",
        tag = "*",
        event = "InsertEnter",
    },
    {
        'simrat39/symbols-outline.nvim',
        event = "BufRead",
        config = function()
            require('custom.mapping').symbols_outline()
        end,
    },
    {
        'williamboman/nvim-lsp-installer',
        config = function()
            -- require('custom.plugins.lspconfig').config_lsp_installer()
        end,
    },
    {
        "mfussenegger/nvim-dap",
        config = function()
            require("custom.plugins.dap").dap.config()
        end,
        disabled = not settings.status.dap,
    },
    {
        'theHamsta/nvim-dap-virtual-text',
        config = function()
            require("nvim-dap-virtual-text").setup()
        end,
        after = 'nvim-dap',
    },
    {
        "rcarriga/nvim-dap-ui",
        requires = {"mfussenegger/nvim-dap"},
        after = 'nvim-dap',
        config = function()
            require("custom.plugins.dap").dapui.config()
        end,
    },
    {
        'nvim-telescope/telescope-dap.nvim',
        requires = {'nvim-dap', 'telescope.nvim'},
        after = 'nvim-dap',
        config = function()
            require('telescope').load_extension('dap')
            vim.cmd "silent! command Vars lua require'telescope'.extensions.dap.variables{}"
            vim.cmd "silent! command Breakpoints lua require'telescope'.extensions.dap.list_breakpoints{}"
        end,
    },
    {
        'mfussenegger/nvim-dap-python',
        requires = {'nvim-dap'},
        config = function()
            require('dap-python').setup('~/python/venvs/debugpy/bin/python')
            local dap = require('dap')
            table.insert(dap.configurations.python, {
                -- The first three options are required by nvim-dap
                type = 'python'; -- the type here established the link to the adapter definition: `dap.adapters.python`
                request = 'launch';
                name = "Launch file in venv";

                -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

                program = "${file}"; -- This configuration will launch the current file if used.
                pythonPath = require('custom.utils').locate_python_executable(),
            })
        end,
    },
    {
        'Shatur/neovim-session-manager',
        config = function()
            require('session_manager').setup({
                path_replacer = '__', -- The character to which the path separator will be replaced for session files.
                colon_replacer = '++', -- The character to which the colon symbol will be replaced for session files.
                autoload_mode = require('session_manager.config').AutoloadMode.CurrentDir, -- Define what to do when Neovim is started without arguments. Possible values: Disabled, CurrentDir, LastSession
                autosave_last_session = true, -- Automatically save last session on exit and on session switch.
                autosave_ignore_not_normal = true, -- Plugin will not save a session when no buffers are opened, or all of them aren't writable or listed.
                autosave_ignore_filetypes = { -- All buffers of these file types will be closed before the session is saved.
                    'gitcommit',
                }, 
                autosave_only_in_session = false, -- Always autosaves session. If true, only autosaves after a session is active.
                max_path_length = 80,  -- Shorten the display path if length exceeds this threshold. Use 0 if don't want to shorten the path at all.
            })
        end
    },
}
