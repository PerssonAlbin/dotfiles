return {
	"jpmcb/nvim-llama",

	config = function()
		require('nvim-llama').setup({
			debug = true,
			model = "codellama",
		})
	end
}
