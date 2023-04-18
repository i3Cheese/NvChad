local M = {}

function M.setup()
    require("harpoon").setup({
        global_settings = {
            save_on_toggle = true,
            save_on_change = true,
        },
        -- projects = {
        --     ["~/Documents/Projects"] = {
        --         term = { cmd = "kitty" },
        --         files = { "harpoon.lua", "README.md" },
        --     },
        -- },
    })
    require("telescope").load_extension('harpoon')
    require("core.mappings").harpoon()
end

return M
