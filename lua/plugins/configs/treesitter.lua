local M = {}

local ensure_installed = {
    "lua",
    "vim",
    "python",
    "cpp",
    "yaml",
    "json",
    "html",
    "javascript",
    "c",
}

local max_filesize = 100 * 1024 -- 100 KB

local function file_too_large(buf)
    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
    return ok and stats and stats.size > max_filesize
end

M.setup = function()
    require("nvim-treesitter").setup()
    require("nvim-treesitter").install(ensure_installed)

    -- nvim-treesitter (main) no longer manages highlighting itself: attach it
    -- by hand for every filetype whose parser we install (nvim core already
    -- does this for a handful of filetypes, e.g. lua/markdown/help)
    vim.api.nvim_create_autocmd("FileType", {
        pattern = ensure_installed,
        callback = function(args)
            if file_too_large(args.buf) then
                return
            end
            pcall(vim.treesitter.start, args.buf)
        end,
    })
end

-- Incremental selection: nvim-treesitter (main) dropped this module, so it's
-- reimplemented here on top of the core vim.treesitter node API.
local incremental_selection = (function()
    local node_stack = {}

    local function select_node(node)
        local srow, scol, erow, ecol = node:range()
        vim.api.nvim_win_set_cursor(0, { srow + 1, scol })
        vim.cmd("normal! v")
        vim.api.nvim_win_set_cursor(0, { erow + 1, math.max(ecol - 1, 0) })
    end

    local M2 = {}

    M2.init_selection = function()
        local node = vim.treesitter.get_node()
        if not node then
            return
        end
        node_stack = { node }
        select_node(node)
    end

    M2.node_incremental = function()
        local node = node_stack[#node_stack]
        if not node then
            return M2.init_selection()
        end
        local parent = node:parent()
        if parent and parent ~= node then
            table.insert(node_stack, parent)
            select_node(parent)
        end
    end

    M2.node_decremental = function()
        if #node_stack > 1 then
            table.remove(node_stack)
            select_node(node_stack[#node_stack])
        end
    end

    -- there's no dedicated "scope" query lookup anymore without the old
    -- locals-based module; fall back to widening the node selection instead
    M2.scope_incremental = M2.node_incremental

    return M2
end)()

M.setup_textobjects = function()
    local mapping = require("core.mappings").treesitter

    require("nvim-treesitter-textobjects").setup({
        select = { lookahead = true },
        move = { set_jumps = true },
    })

    local select = require("nvim-treesitter-textobjects.select")
    for key, query in pairs(mapping.select) do
        vim.keymap.set({ "x", "o" }, key, function()
            select.select_textobject(query, "textobjects")
        end)
    end

    local move = require("nvim-treesitter-textobjects.move")
    for action, keys in pairs(mapping.move) do
        for key, query in pairs(keys) do
            vim.keymap.set({ "n", "x", "o" }, key, function()
                move[action](query, "textobjects")
            end)
        end
    end

    local swap = require("nvim-treesitter-textobjects.swap")
    for key, query in pairs(mapping.swap.swap_next) do
        vim.keymap.set("n", key, function()
            swap.swap_next(query)
        end)
    end
    for key, query in pairs(mapping.swap.swap_previous) do
        vim.keymap.set("n", key, function()
            swap.swap_previous(query)
        end)
    end

    local sel = mapping.incremental_selection
    vim.keymap.set("n", sel.init_selection, incremental_selection.init_selection)
    vim.keymap.set("x", sel.node_incremental, incremental_selection.node_incremental)
    vim.keymap.set("x", sel.node_decremental, incremental_selection.node_decremental)
    vim.keymap.set("x", sel.scope_incremental, incremental_selection.scope_incremental)
end

return M
