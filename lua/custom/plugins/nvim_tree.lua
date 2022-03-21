local M = {}

vim.g.nvim_tree_icons = {
    default = "",
    symlink = '',
    git = {
        unstaged = "✗",
        staged = "✓",
        unmerged = "",
        renamed = "➜",
        untracked = "★",
        deleted = "",
        ignored = "◌"
    },
    folder = {
        arrow_open = "",
        arrow_closed = "",
        default = "",
        open = "",
        empty = "",
        empty_open = "",
        symlink = "",
        symlink_open = "",
    }
}

M.config = {
    filters = {
        dotfiles = false,
        custom = {
            "__pycache__",
        }
    },
    disable_netrw = true,
    hijack_netrw = true,
    auto_close = false,
    open_on_tab = false,
    hijack_cursor = true,
    update_cwd = true,
    update_focused_file = {
       enable = true,
       update_cwd = false,
    },
    view = {
       allow_resize = true,
       side = "left",
       width = 30,
       hide_root_folder = true,
    },
    git = {
       enable = true,
       ignore = false,
       timeout = 4000,
    },
}

return M
