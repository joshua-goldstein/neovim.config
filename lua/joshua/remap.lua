local opts = { noremap = true, silent = true }
local term_opts = { silent = true }

-- convenience function
-- :help nvim_set_keymap
local keymap = vim.api.nvim_set_keymap
-- can also use keymap = vim.keymap.set

-- must happen before plugins are required (otherwise wrong leader will be used)
-- me `:help mapleader`
-- from chris@machine: what is this doing? 
-- -keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-- https://www.reddit.com/r/vim/comments/1vdrxg/space_is_a_big_key_what_do_you_map_it_to/
-- keymap("", " ", "<leader>", { silent = true })

vim.keymap.set("n", "<leader>p", vim.cmd.Ex)

-- resize with arrows
keymap("n", "<C-Up>", ":resize +2<CR>", opts)
keymap("n", "<C-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- use esc to exit terminal mode
-- see :help terminal-emulator
keymap("t", "<Esc>", "<C-\\><C-n>", opts)

-- keymaps for telescope
-- keymap("n", "<leader>f", "<cmd>Telescope find_files<cr>", opts)
keymap("n", "<leader>f", "<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ previewer = false }))<cr>", opts)
keymap("n", "<leader>F", "<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_ivy({ previewer = true }))<cr>", opts)
keymap("n", "<c-t>", "<cmd>Telescope live_grep<cr>", opts)

-- center screen after jumping up / down 
keymap("n", "<C-d>", "<C-d>zz", opts)
keymap("n", "<C-u>", "<C-u>zz", opts)
keymap("n", "n", "nzzzv", opts)
keymap("n", "N", "Nzzzv", opts)
