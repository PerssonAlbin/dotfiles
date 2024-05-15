local map = vim.keymap.set

local default_options = { silent = true }
local expr_options = { expr = true, silent = true }

--Remap leader key
map({ "n", "v" }, "<Space>", "<Nop>", default_options)
vim.g.mapleader = " "

-- Close search
map("n", "<ESC>", ":nohlsearch<Bar>:echo<CR>", default_options)

-- Nvim Tree
map("n", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true, desc = "Toggle file explorer" })

-- Bufferline
map("n", "<TAB>", ":bnext<CR>", default_options)
map("n", "<S-TAB>", ":bprevious<CR>", default_options)
map("n", "<C-q>", ":bp<bar>sp<bar>bn<bar>bd<CR>", default_options)

-- Telescope
map("n", "<leader>ff", ":Telescope find_files<CR>", { noremap = true, desc = "Telescope: find files" })
map("n", "<leader>fg", ":Telescope live_grep<CR>", { noremap = true, desc = "Telescope: find string" })
map("n", "<leader>fb", ":Telescope buffers<CR>", { noremap = true, desc = "Telescope: find open buffer" })
map("n", "<leader>fh", ":Telescope help_tags<CR>", { noremap = true })
map("n", "<leader>fc", ":Telescope grep_string<cr>", { noremap = true, desc = "Telescope: find string under cursor" })

-- Telescope cmd
vim.api.nvim_set_keymap('n', ':', ':Telescope cmdline<CR>', { noremap = true, desc = "Cmdline" })
vim.api.nvim_set_keymap('n', '<leader><leader>', ':Telescope cmdline<CR>', { noremap = true, desc = "Cmdline" })
