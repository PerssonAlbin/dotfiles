return {
	"stevearc/conform.nvim",
	lazy = true,
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				C = { "clang-format" },
				cpp = { "clang-format" },
				python = { "black" },
				cmake = { "cmakelang" },
				json = { "prettier" },
			},
			format_on_save = {
				lsp_format = "fallback",
				timeout = 5000,
			},
		})
	end,
}
