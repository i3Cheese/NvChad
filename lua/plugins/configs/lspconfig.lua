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
    -- bun add -g vscode-langservers-extracted
    require("lspconfig").html.setup(opts)
end

local function setup_js(opts)
    opts = vim.deepcopy(opts)
    require("lspconfig").tsserver.setup(opts)
end

local function setup_rust_analyser(opts)
    opts = vim.deepcopy(opts)
    require("lspconfig").rust_analyzer.setup(opts)
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
    opts.on_init = function(client)
        local path = client.workspace_folders[1].name
        if not vim.loop.fs_stat(path .. '/.luarc.json') and not vim.loop.fs_stat(path .. '/.luarc.jsonc') then
            client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
                Lua = {
                    runtime = {
                        -- Tell the language server which version of Lua you're using
                        -- (most likely LuaJIT in the case of Neovim)
                        version = 'LuaJIT'
                    },
                    -- Make the server aware of Neovim runtime files
                    workspace = {
                        checkThirdParty = false,
                        library = {
                            vim.env.VIMRUNTIME
                            -- "${3rd}/luv/library"
                            -- "${3rd}/busted/library",
                        }
                        -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                        -- library = vim.api.nvim_get_runtime_file("", true)
                    }
                }
            })

            client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
        end
        return true
    end
    require("lspconfig").lua_ls.setup(opts)
end

local function setup_cpp(opts)
    opts = vim.deepcopy(opts)
    opts.cmd = { "clangd" }
    opts.capabilities.offsetEncoding = { "utf-16" }
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
    setup_js(opts)
    setup_rust_analyser(opts)
end

M.setup = function()
    require("plugins.configs.others").lsp_handlers()
    setup_servers()

    require("core.mappings").lspconfig()
end

M.setup_null_ls = function()
    local null_ls = require("null-ls")
    null_ls.setup({
        debug = true,
        sources = {
            -- null_ls.builtins.formatting.autopep8.with({
            --     extra_args = { "--ignore=E402" },
            -- }),
            null_ls.builtins.formatting.black,
            null_ls.builtins.formatting.brittany,
            -- null_ls.builtins.code_actions.gitsigns,
            null_ls.builtins.formatting.prettier,
            null_ls.builtins.formatting.djhtml,
            null_ls.builtins.formatting.gofmt,
            null_ls.builtins.formatting.rustfmt,
            null_ls.builtins.hover.dictionary,
        },
    })
end

return M
