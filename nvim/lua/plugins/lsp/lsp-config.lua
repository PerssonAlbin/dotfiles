return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		local cmp_nvim_lsp = require("cmp_nvim_lsp")



		-- Change the Diagnostic symbols in the sign column (gutter)
		-- (not in youtube nvim video)
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		local normal_capabilties = vim.lsp.protocol.make_client_capabilities()
		local capabilities = cmp_nvim_lsp.default_capabilities(normal_capabilties)

		vim.lsp.config("clangd", {
			capabilities = capabilities,
			on_attach = on_attach,
		})

		vim.lsp.config("lua_ls", {
			capabilities = capabilities,
			on_attach = on_attach,
			settings = { -- custom settings for lua
				Lua = {
					-- make the language server recognize "vim" global
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						-- make language server aware of runtime files
						library = {
							[vim.fn.expand("$VIMRUNTIME/lua")] = true,
							[vim.fn.stdpath("config") .. "/lua"] = true,
						},
					},
				},
			},
		})

		vim.lsp.config("volar", {
			capabilities = capabilities,
			on_attach = on_attach,
		})

		vim.lsp.config("bashls", {
			capabilities = capabilities,
			on_attach = on_attach,

			filetypes = { "sh" },
		})

		vim.lsp.config("bitbake_ls", {
			on_attach = function(client)
				client.server_capabilities.semanticTokensProvider = vim.NIL
			end,
		})

		vim.lsp.config("ginko_ls", {
			on_attach = on_attach,
			capabilities = capabilities,
		})

		vim.lsp.config("elixirls", {
			cmd = { "/home/denmarkpolice/.local/share/nvim/mason/packages/elixir-ls/language_server.sh" },
			filetypes = { "elixir" },
			on_attach = function(client, bufnr)
				local filetype = vim.bo[bufnr].filetype

				if filetype ~= "elixir" and filetype ~= "eelixir" then
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false
					vim.lsp.buf_detach_client(bufnr, client.id)
					return
				end
			end,
		})
	end
}
