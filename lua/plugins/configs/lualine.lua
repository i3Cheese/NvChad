local M = {}

local function dir_name()
    return " 󰉖 " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t") .. " "
end

local function file_type()
    return "[" .. vim.bo.filetype:upper() .. "]"
end

local function theme(colors)
    local a_by_mode = {
        normal = colors.light_grey,
        insert = colors.purple,
        visual = colors.cyan,
        replace = colors.orange,
        command = colors.pink,
        inactive = colors.grey_fg2,
    }

    local shared_b = { fg = colors.grey_fg2, bg = colors.statusline_bg }
    local shared_c = { fg = colors.white, bg = colors.lightbg }

    local t = {}
    for mode, color in pairs(a_by_mode) do
        t[mode] = {
            a = { fg = colors.black, bg = color, gui = "bold" },
            b = shared_b,
            c = shared_c,
        }
    end
    t.inactive.a.fg = colors.grey_fg2
    return t
end

M.setup = function()
    local colors = require("colors").get()

    require("lualine").setup({
        options = {
            theme = theme(colors),
            component_separators = "",
            section_separators = { left = "", right = "" },
            globalstatus = true,
            disabled_filetypes = {
                statusline = {
                    "Alpha",
                    "NvimTree",
                    "packer",
                    "startify",
                    "fugitive",
                    "fugitiveblame",
                    "qf",
                    "help",
                },
            },
        },
        sections = {
            lualine_a = { "mode" },
            lualine_b = {
                { "branch", icon = "" },
                { "diff", symbols = { added = "  ", modified = "  ", removed = "  " } },
            },
            lualine_c = {
                dir_name,
                { "filename", path = 1, symbols = { modified = " ●", readonly = " " } },
            },
            lualine_x = {
                {
                    "diagnostics",
                    sources = { "nvim_diagnostic" },
                    symbols = { error = "  ", warn = "  ", info = " 󰋼 ", hint = " 󰌶 " },
                },
            },
            lualine_y = { file_type },
            lualine_z = { "location", "progress" },
        },
        winbar = {},
        inactive_winbar = {},
    })
end

return M
