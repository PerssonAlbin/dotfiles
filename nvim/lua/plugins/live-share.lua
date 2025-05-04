return {
	"azratul/live-share.nvim",
	dependencies = { 'jbyuki/instant.nvim' },
	config = function()
		local liveshare = require("live-share")
		vim.g.instant_username = "Albin"
		liveshare.setup({
			max_attempts = 40, -- 10 seconds
			service = "serveo.net"
		})
	end,
}
