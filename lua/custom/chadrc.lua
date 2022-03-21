local myPlugins = require "custom.plugins"

M = {}


M.plugins = {
    -- enable/disable plugins (false for disable)
    install = myPlugins,
    status = {
        bufferline = true, -- manage and preview opened buffers
        alpha = true,
        snippets = true,
    },
    options = {
        lspconfig = {
            setup_lspconf = "custom.plugins.lspconfig",
        },
        nvimtree = {
            enable_git = 1,
        }
    },
    default_plugin_config_replace = {
        nvim_tree = require("custom.plugins.nvim_tree").config,
        telescope = require("custom.plugins.telescope").config,
        feline = function()
            require("custom.plugins.feline").setup()
        end,
    },
}

M.options = {
    snippets = true,
    relativenumber = true,
    tabstop = 4,
    shiftwidth = 4,
    smarttab = true,
    expandtab = true,
    autoindent = false,
    nvChad = {
        copy_cut = false, -- copy cut text ( x key ), visual and normal mode
        copy_del = true, -- copy deleted text ( dd key ), visual and normal mode
        insert_nav = true, -- navigation in insertmode
        window_nav = true,
    },
    clipboard="",
}

return M
