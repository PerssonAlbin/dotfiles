return {
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPre", "BufNewFile" },
		build = ":TSUpdate",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"windwp/nvim-ts-autotag",
		},
		config = function()
			local treesitter = require("nvim-treesitter.configs")

			treesitter.setup({ -- enable syntax highlighting
				highlight = {
					enable = true,
				},
				indent = { enable = true },

				autotag = {
					enable = true,
				},

				ensure_installed = {
					"bash",
					"c",
					"cpp",
					"css",
					"cuda",
					"devicetree",
					"diff",
					"dockerfile",
					"elixir",
					"eex",
					"faust",
					"gitignore",
					"html",
					"javascript",
					"json",
					"lua",
					"make",
					"markdown",
					"markdown_inline",
					"python",
					"toml",
					"tsx",
					"typescript",
					"vue",
					"yaml",
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<CR>",
						scope_incremental = "<CR>",
						node_incremental = "<TAB>",
						node_decremental = "<S-TAB>",
					},
				},
			})
		end,
	},
}
