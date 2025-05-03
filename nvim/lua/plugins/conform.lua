return {
	"stevearc/conform.nvim",
	lazy = true,
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				C = { "clang-format" },
				cmake = { "cmakelang" },
				cpp = { "clang-format" },
				javascript = { "prettier" },
				json = { "prettier" },
				python = { "black" },
			},
			format_on_save = {
				lsp_format = "fallback",
				timeout = 5000,
			},
		})
	end,
}
