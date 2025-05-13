return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"jonarrien/telescope-cmdline.nvim",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		telescope.setup({
			defaults = {
				layout_strategy = "vertical",
				layout_config = {
					vertical = {
						prompt_position = "bottom",
						width = { padding = 5 },
						height = { padding = 5 },
						preview_width = 0.5,
					},
					width = 0.90,
					height = 0.90,
				},
				path_display = { "truncate " },
				file_ignore_patterns = { "^node_modules/", "^build/", "^dist/" },
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
					},
				},
			},
			extensions = {
				cmdline = {
					mappings = {
						complete      = '<Tab>',
						run_selection = '<C-CR>',
						run_input     = '<CR>',
					},
					overseer = {
						enabled = true,
					},
				},
			}
		})

		telescope.load_extension("fzf")
		telescope.load_extension("cmdline")
	end,
}
