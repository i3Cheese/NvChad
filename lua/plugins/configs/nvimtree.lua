local M = {}

vim.g.nvim_tree_add_trailing = 0 -- append a trailing slash to folder names
vim.g.nvim_tree_git_hl = 0
vim.g.nvim_tree_highlight_opened_files = 0
vim.g.nvim_tree_indent_markers = 1
vim.g.nvim_tree_root_folder_modifier = table.concat { ":t:gs?$?/..", string.rep(" ", 1000), "?:gs?^??" }

vim.g.nvim_tree_icons = {
    default = "",
    symlink = "",
    git = {
        unstaged = "✗",
        staged = "✓",
        unmerged = "",
        renamed = "➜",
        untracked = "★",
        deleted = "",
        ignored = "◌",
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
    },
}

M.config = {
    filters = {
        dotfiles = false,
        custom = {
            "__pycache__",
        },
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

M.setup = function()
    require("nvim-tree").setup(M.config)
end

return M
