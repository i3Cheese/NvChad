local M = {}

local function on_attach(client, bufnr)
    local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end

    client.server_capabilities.document_formatting = false
    client.server_capabilities.document_range_formatting = false
    -- Enable completion triggered by <c-x><c-o>
    buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
end

local function setup_lsp_installer()
    local lsp_installer = require("nvim-lsp-installer")

    lsp_installer.settings({
        ui = {
            icons = {
                server_installed = "﫟",
                server_pending = "",
                server_uninstalled = "✗",
            },
        },
    })
    lsp_installer.setup({})
end

local function setup_pyright(opts)
    opts = vim.deepcopy(opts)
    opts.on_init = function(client)
        client.config.settings.python.pythonPath =
        require("core.utils").locate_python_executable(client.config.root_dir)
    end
    require("lspconfig").pyright.setup(opts)
end

local function setup_html(opts)
    opts = vim.deepcopy(opts)
    opts.filetypes = { "html", "htmldjango" }
    require("lspconfig").html.setup(opts)
end

local function setup_latex(opts)
    opts = vim.deepcopy(opts)
    opts.settings = {
        texlab = {
            rootDirectory = nil,
            build = {
                executable = 'latexmk',
                args = { '-pdf', '-interaction=nonstopmode', '-synctex=1', '%f' },
                onSave = true,
                forwardSearchAfter = false,
            },
        }
    }
    require("lspconfig").texlab.setup(opts)
end

local function setup_lua(opts)
    opts = vim.deepcopy(opts)
    local runtime_path = vim.split(package.path, ";")
    table.insert(runtime_path, "lua/?.lua")
    table.insert(runtime_path, "lua/?/init.lua")
    opts.settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
                path = runtime_path,
            },
            completion = {
                callSnippet = "Replace",
            },
            diagnostics = {
                enable = true,
                globals = { "vim", "use" },
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                maxPreload = 10000,
                preloadFileSize = 10000,
            },
            telemetry = { enable = false },
        },
    }
    require("lspconfig").sumneko_lua.setup(opts)
end

local function setup_cpp(opts)
    opts = vim.deepcopy(opts)
    require("lspconfig").clangd.setup(opts)
end

local function setup_servers()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.documentationFormat = { "markdown", "plaintext" }
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.preselectSupport = true
    capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
    capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
    capabilities.textDocument.completion.completionItem.deprecatedSupport = true
    capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
    capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
    capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = {
            "documentation",
            "detail",
            "additionalTextEdits",
        },
    }
    local opts = {
        on_attach = on_attach,
        capabilities = capabilities,
        flags = {
            debounce_text_changes = 150,
        },
        settings = {},
    }
    setup_pyright(opts)
    setup_html(opts)
    setup_lua(opts)
    setup_cpp(opts)
    setup_latex(opts)
end

M.setup = function()
    require("plugins.configs.others").lsp_handlers()
    setup_lsp_installer()
    setup_servers()

    require("core.mappings").lspconfig()
end

return M
