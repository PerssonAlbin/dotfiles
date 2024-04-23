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
				path_display = { "truncate " },
				file_ignore_patterns = { "^node_modules/", "^build/", "^dist/" },
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
					},
				},
			},
			extensions = {
				cmdline = {
					picker   = {
						layout_config = {
							width  = 120,
							height = 25,
						}
					},
					mappings = {
						complete      = '<Tab>',
						run_selection = '<C-CR>',
						run_input     = '<CR>',
					},
				},
			}
		})

		telescope.load_extension("fzf")
		telescope.load_extension("cmdline")
	end,
}
