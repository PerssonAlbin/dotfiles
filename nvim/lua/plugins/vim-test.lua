return {
	"vim-test/vim-test",
	keys = {
		{ "<leader>Tf", "<cmd>TestFile<cr>",    silent = true, desc = "Run this file" },
		{ "<leader>Tn", "<cmd>TestNearest<cr>", silent = true, desc = "Run nearest test" },
		{ "<leader>Tl", "<cmd>TestLast<cr>",    silent = true, desc = "Run last test" },
	},
}
