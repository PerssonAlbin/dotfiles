-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require "options"

require "autocmd"
require "mappings"
require "lazy-conf"

require "theme_selector"
