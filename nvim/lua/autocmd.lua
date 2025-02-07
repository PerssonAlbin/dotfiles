local api = vim.api

-- don't auto comment new line
api.nvim_create_autocmd("BufEnter", { command = [[set formatoptions-=cro]] })

-- Close nvim if NvimTree is only running buffer
api.nvim_create_autocmd(
	"BufEnter",
	{ command = [[if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif]] }
)

-- show cursor line only in active window
local cursorGrp = api.nvim_create_augroup("CursorLine", { clear = true })
api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
	pattern = "*",
	command = "set cursorline",
	group = cursorGrp,
})
api.nvim_create_autocmd(
	{ "InsertEnter", "WinLeave" },
	{ pattern = "*", command = "set nocursorline", group = cursorGrp }
)

-- Enable spell checking for certain file types
api.nvim_create_autocmd(
	{ "BufRead", "BufNewFile" },
	{ pattern = { "*.txt", "*.md", "*.tex" }, command = "setlocal spell" }
)

api.nvim_create_autocmd({ "BufWritePre" }, {
	pattern = "*",
	buffer = buffer,
	callback = function()
		vim.lsp.buf.format { async = false }
	end
})

-- Highlight trailing spaces and tabs
vim.api.nvim_create_autocmd('ColorScheme', {
	pattern = "*",
	callback = function()
		local error_hl = vim.api.nvim_get_hl(0, { name = "Error" })
		local error_color = error_hl.fg

		vim.api.nvim_set_hl(0, 'ShowWhitespace', { bg = error_color })
	end
})

api.nvim_create_autocmd("BufEnter", {
	pattern = "*",
	callback = function()
		vim.fn.matchadd('ShowWhitespace', [[\s\+$]]) -- Highlight trailing spaces
		vim.fn.matchadd('ExtraWhitespace', [[^\t\+]]) -- Highlight trailing tabs
	end
})
