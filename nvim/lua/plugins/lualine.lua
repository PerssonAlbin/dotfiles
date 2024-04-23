return {
	'nvim-lualine/lualine.nvim',
	dependencies = { 'nvim-tree/nvim-web-devicons' },
	config = function()
		require('lualine').setup({
			options = {
				theme = 'auto',
				icons_enabled = true,
				always_divide_middle = false,
				component_separators = '',
				section_separators = '',
			},
			sections = {
				lualine_a = { 'mode' },
				lualine_b = { 'branch', 'diff', 'diagnostics' },
				lualine_c = { 'filename' },

				lualine_x = { 'filetype' },
				lualine_y = { 'searchcount' },
				lualine_z = { 'location' }
			},
		})
	end,
};
