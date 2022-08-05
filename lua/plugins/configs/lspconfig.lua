local M = {}

local function on_attach(client, bufnr)
	local function buf_set_option(...)
		vim.api.nvim_buf_set_option(bufnr, ...)
	end

	client.resolved_capabilities.document_formatting = false
	client.resolved_capabilities.document_range_formatting = false
	-- Enable completion triggered by <c-x><c-o>
	buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
end

local setup_lsp = function(capabilities)
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

	lsp_installer.on_server_ready(function(server)
		local opts = {
			on_attach = on_attach,
			capabilities = capabilities,
			flags = {
				debounce_text_changes = 150,
			},
			settings = {},
		}
		if server.name == "pyright" then
			opts.on_init = function(client)
				client.config.settings.python.pythonPath =
					require("core.utils").locate_python_executable(client.config.root_dir)
			end
		elseif server.name == "html" then
			opts.filetypes = { "html", "htmldjango" }
		elseif server.name == "sumneko_lua" then
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
		end

		server:setup(opts)
		vim.cmd([[ do User LspAttachBuffers ]])
	end)
end

M.setup = function()
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
	require("plugins.configs.others").lsp_handlers()
	setup_lsp(capabilities)

	require("core.mappings").lspconfig()
	lspconfig = require("lspconfig")
	lspconfig.clangd.setup({
		on_attach = on_attach,
		capabilities = capabilities,
		flags = {
			debounce_text_changes = 150,
		},
		settings = {},
	})
end

return M
