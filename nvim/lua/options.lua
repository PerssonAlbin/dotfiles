local opt = vim.opt
local fn = vim.fn

opt.backup = false                     -- Disable backup files
opt.clipboard = "unnamedplus"          -- Neovim uses system clipboard
opt.cmdheight = 1
opt.dir = fn.stdpath("data") .. "/swp" -- Swap file directory
opt.fileencoding = "utf-8"
opt.hlsearch = true
opt.ignorecase = true
opt.mouse = "a" -- Mouse in all modes
opt.number = true
opt.scrolloff = 4
opt.shiftwidth = 2
opt.showtabline = 2
opt.smartcase = true   -- smart case
opt.smartindent = true -- make indenting smarter again
opt.spell = true
opt.spelllang = "en_us"
opt.swapfile = true -- Enable swap files
opt.tabstop = 2
opt.termguicolors = true
opt.undodir = fn.stdpath("data") .. "/undodir" -- Undo file directory
opt.undofile = true                            -- Enable Undo files
opt.wildmode = "full"
opt.wildignorecase = true
opt.wildignore = [[
.git,.hg,.svn
*.aux,*.out,*.toc
*.o,*.obj,*.exe,*.dll,*.manifest,*.rbc,*.class
*.ai,*.bmp,*.gif,*.ico,*.jpg,*.jpeg,*.png,*.psd,*.webp
*.avi,*.divx,*.mp4,*.webm,*.mov,*.m2ts,*.mkv,*.vob,*.mpg,*.mpeg
*.mp3,*.oga,*.ogg,*.wav,*.flac
*.eot,*.otf,*.ttf,*.woff
*.doc,*.pdf,*.cbr,*.cbz
*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz,*.kgb
*.swp,.lock,.DS_Store,._*
*/tmp/*,*.so,*.swp,*.zip,**/node_modules/**,**/target/**,**.terraform/**"
]]
