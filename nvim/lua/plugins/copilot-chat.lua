return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim", branch = "master" },
    },
    build = "make tiktoken", -- Optional token counter
    opts = {
      -- See Configuration options: https://github.com/CopilotC-Nvim/CopilotChat.nvim/blob/main/lua/CopilotChat/config.lua
			model = 'claude-sonnet-4.6',
			window = {
				layout = 'horizontal',
				height = 0.25,
			},
			headers = {
    		user = '👤 You',
    		assistant = '🤖 Copilot',
    		tool = '🔧 Tool',
  		},
    },
  },
}
