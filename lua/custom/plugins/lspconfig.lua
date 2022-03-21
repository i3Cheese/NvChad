local M = {}


M.setup_lsp = function(attach, capabilities)
    local lsp_installer = require "nvim-lsp-installer"

    lsp_installer.settings {
        ui = {
            icons = {
                server_installed = "﫟" ,
                server_pending = "",
                server_uninstalled = "✗",
          },
       },
    }

    lsp_installer.on_server_ready(function(server)
        local opts = {
            on_attach = attach,
            capabilities = capabilities,
            flags = {
                debounce_text_changes = 150,
            },
            settings = {},
        }
        if (server.name == 'pyright') then
            opts.venv = require('custom.utils').locate_python_venv()
        end

        server:setup(opts)
        vim.cmd [[ do User LspAttachBuffers ]]
    end)
    require('custom.mapping').lsp()
end

return M
