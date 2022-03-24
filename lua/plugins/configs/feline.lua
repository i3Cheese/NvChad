local present, feline = pcall(require, "feline")
if not present then
    return
end

local colors = require("colors").get()
local lsp = require "feline.providers.lsp"
local lsp_severity = vim.diagnostic.severity

local icons = {
    left = "",
    right = "",
    main_icon = "  ",
    vi_mode_icon = " ",
    position_icon = "ﳨ ",
}

local file_name = {
    provider = function()
        local filename = vim.fn.fnamemodify(vim.fn.expand "%", ":~:.")
        local extension = vim.fn.expand "%:e"
        local icon = require("nvim-web-devicons").get_icon(filename, extension)
        if icon == nil then
            icon = ""
        end
        return " " .. icon .. " " .. filename .. " "
    end,
    short_provider = function()
        local filename = vim.fn.expand "%:t"
        local extension = vim.fn.expand "%:e"
        local icon = require("nvim-web-devicons").get_icon(filename, extension)
        if icon == nil then
            icon = ""
        end
        return " " .. icon .. " " .. filename .. " "
    end,
    hl = {
        fg = colors.white,
        bg = colors.lightbg,
    },
    priority = 10,

    right_sep = {
        str = icons.right,
        hl = { fg = colors.lightbg, bg = colors.statusline_bg },
    },
}

local dir_name = {
    provider = function()
        local dir_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
        return "  " .. dir_name .. " "
    end,

    hl = {
        fg = colors.grey_fg2,
        bg = colors.lightbg2,
    },
    truncate_hide = true,
    priority = 5,
}

local git_branch = {
    provider = "git_branch",
    hl = {
        fg = colors.grey_fg2,
        bg = colors.statusline_bg,
    },
    icon = "  ",
    truncate_hide = true,
}

local diff = {
    add = {
        provider = "git_diff_added",
        hl = {
            fg = colors.grey_fg2,
            bg = colors.statusline_bg,
        },
        icon = "  ",
        truncate_hide = true,
        priority = 3,
    },

    change = {
        provider = "git_diff_changed",
        hl = {
            fg = colors.grey_fg2,
            bg = colors.statusline_bg,
        },
        icon = "  ",
        truncate_hide = true,
        priority = 3,
    },

    remove = {
        provider = "git_diff_removed",
        hl = {
            fg = colors.grey_fg2,
            bg = colors.statusline_bg,
        },
        icon = "  ",
        truncate_hide = true,
        priority = 3,
    },
}

local diagnostic = {
    error = {
        provider = "diagnostic_errors",
        enabled = function()
            return lsp.diagnostics_exist(lsp_severity.ERROR)
        end,

        hl = { fg = colors.red },
        icon = "  ",
        truncate_hide = true,
        priority = 4,
    },

    warning = {
        provider = "diagnostic_warnings",
        enabled = function()
            return lsp.diagnostics_exist(lsp_severity.WARN)
        end,
        hl = { fg = colors.yellow },
        icon = "  ",
        truncate_hide = true,
        priority = 4,
    },

    hint = {
        provider = "diagnostic_hints",
        enabled = function()
            return lsp.diagnostics_exist(lsp_severity.HINT)
        end,
        hl = { fg = colors.grey_fg2 },
        icon = "  ",
        truncate_hide = true,
        priority = 4,
    },

    info = {
        provider = "diagnostic_info",
        enabled = function()
            return lsp.diagnostics_exist(lsp_severity.INFO)
        end,
        hl = { fg = colors.green },
        icon = "  ",
        truncate_hide = true,
        priority = 4,
    },
}

local mode_colors = {
    ["n"] = { "NORMAL", colors.red },
    ["no"] = { "N-PENDING", colors.red },
    ["i"] = { "INSERT", colors.dark_purple },
    ["ic"] = { "INSERT", colors.dark_purple },
    ["t"] = { "TERMINAL", colors.green },
    ["v"] = { "VISUAL", colors.cyan },
    ["V"] = { "V-LINE", colors.cyan },
    [""] = { "V-BLOCK", colors.cyan },
    ["R"] = { "REPLACE", colors.orange },
    ["Rv"] = { "V-REPLACE", colors.orange },
    ["s"] = { "SELECT", colors.nord_blue },
    ["S"] = { "S-LINE", colors.nord_blue },
    [""] = { "S-BLOCK", colors.nord_blue },
    ["c"] = { "COMMAND", colors.pink },
    ["cv"] = { "COMMAND", colors.pink },
    ["ce"] = { "COMMAND", colors.pink },
    ["r"] = { "PROMPT", colors.teal },
    ["rm"] = { "MORE", colors.teal },
    ["r?"] = { "CONFIRM", colors.teal },
    ["!"] = { "SHELL", colors.green },
}

local mode = {
    provider = function()
        return " " .. mode_colors[vim.fn.mode()][1] .. " "
    end,
    hl = function()
        return {
            fg = mode_colors[vim.fn.mode()][2],
            bg = colors.statusline_bg,
        }
    end,
    left_sep = {
        {
            str = icons.left,
            hl = {
                fg = colors.grey,
                bg = colors.statusline_bg,
            },
        },
        {
            str = icons.left,
            hl = function()
                return {
                    fg = mode_colors[vim.fn.mode()][2],
                    bg = colors.grey,
                }
            end,
        },
    },
    icon = {
        str = icons.vi_mode_icon,
        hl = function()
            return {
                fg = colors.statusline_bg,
                bg = mode_colors[vim.fn.mode()][2],
            }
        end,
    },
    truncate_hide = true,
    priority = 2,
}

local current_line = {
    provider = function()
        local current_line = vim.fn.line "."
        local total_line = vim.fn.line "$"

        if current_line == 1 then
            return "  ﲓ  "
        elseif current_line == vim.fn.line "$" then
            return "  ﲐ  "
        end
        local result, _ = math.modf((current_line / total_line) * 100)
        return " " .. result .. "%% "
    end,

    hl = {
        fg = colors.green,
        bg = colors.statusline_bg,
    },
    left_sep = {
        {
            str = icons.left,
            hl = {
                fg = colors.grey,
                bg = colors.statusline_bg,
            },
        },
        {
            str = icons.left,
            hl = {
                fg = colors.green,
                bg = colors.grey,
            },
        },
    },
    icon = {
        str = icons.position_icon,
        hl = {
            fg = colors.black,
            bg = colors.green,
        },
    },

    truncate_hide = true,
    priority = 1,
}

local M = {}
M.setup = function()
    -- components are divided in 3 sections
    local components = {
        active = {
            { -- left
                dir_name,
                file_name,
                git_branch,
                diff.add,
                diff.change,
                diff.remove,
                diagnostic.error,
                diagnostic.warning,
                diagnostic.info,
                diagnostic.hint,
            },
            { -- right
                mode,
                current_line,
            },
        },
        inactive = {
            { -- left
                dir_name,
                file_name,
            },
        },
    }

    feline.setup {
        theme = {
            bg = colors.statusline_bg,
            fg = colors.fg,
        },
        components = components,
        force_inactive = {
            filetypes = {},
            bufnames = {},
        },
        disable = {
            filetypes = {
                "^NvimTree$",
                "^packer$",
                "^startify$",
                "^fugitive$",
                "^fugitiveblame$",
                "^qf$",
                "^help$",
            },
            bufnames = {},
        },
    }
end

return M
