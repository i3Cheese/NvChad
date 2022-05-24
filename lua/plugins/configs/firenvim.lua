local M = {}

M.setup = function ()
    local firenvim_config = {}
    firenvim_config.localSettings = {
        [".*"] = {
            priority = 0,
            takeover = "never",
        },
        ["https?://nearcrowd\\.com/*"] = { ["takeover"] = "always", ["priority"] = 1 },
    }
    vim.g.firenvim_config = firenvim_config

    -- Detect filetypes
    local filetypes_group = vim.api.nvim_create_augroup("i3Cheese-filetypes", {
        clear = true,
    })
    vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
        group = filetypes_group,
        pattern = "nearcrowd.com_v2_-TABLE-1-TBODY-1-TR-1-TD-1-DIV-*.txt",
        command = "set ft=go",
        desc = "Detect CrowdScript",
    })
end

return M
