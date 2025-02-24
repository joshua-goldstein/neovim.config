-- references
-- kickstart: https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua
-- primagen: https://github.com/ThePrimeagen/init.lua/blob/master/lua/theprimeagen/set.lua
-- chris@machine: https://github.com/LunarVim/nvim-basic-ide/blob/master/lua/options.lua
-- missing semester MIT


-- :help vim.opt, :help vim.o
-- Make line numbers default
vim.wo.number = true
-- allows neovim to access the system clipboard
vim.opt.clipboard = "unnamedplus"
-- Set highlight on search
vim.o.hlsearch = false
-- allow the mouse to be used in neovim
vim.opt.mouse = "a"
-- Save undo history
vim.o.undofile = true
-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true
-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'
-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true
vim.opt.wrap = false
-- tabs
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
-- status bar
vim.opt.laststatus = 1
