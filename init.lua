-- author: joshua goldstein
-- license: MIT

-- [[ remappings ]]

-- see :h vim.g, :h mapleader, etc.
-- must happen before plugins are loaded (or wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- file explorer
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- move around buffers
vim.keymap.set("n", "<S-l>", ":bnext<CR>") 
vim.keymap.set("n", "<S-h>", ":bprevious<CR>") 

-- resize with arrows
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>")
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>")
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>")
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>")

-- use esc to exit terminal mode
-- see :help terminal-emulator
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

-- center screen after jumping up / down 
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- [[editor options]]

-- equivalent to :set number
vim.opt.number = true
vim.opt.mouse = 'a'
vim.opt.showmode = false
vim.opt.breakindent = true
vim.opt.wrap = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.list = true

-- tab options
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- only show status bar if two windows are open
vim.opt.laststatus = 1

-- split options
vim.opt.splitright = true
vim.opt.splitbelow = true

-- highlight yanked text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[ package manager ]]

-- clone paq if not already present
local clone_paq = function()
  local path = vim.fn.stdpath("data") .. "/site/pack/paqs/start/paq-nvim"
  local is_installed = vim.fn.empty(vim.fn.glob(path)) == 0
  if not is_installed then
    vim.fn.system { "git", "clone", "--depth=1", "https://github.com/savq/paq-nvim.git", path }
    return true
  end
end

local bootstrap_paq = function(packages)
  vim.cmd.packadd("paq-nvim")
  local paq = require("paq")
  paq(packages)
  paq.install()
end

local setup_paq = function(packages)
  local first_install = clone_paq()
  if not first_install then
    local paq = require("paq")
    paq(packages)
  else
    bootstrap_paq(packages)
  end
end

setup_paq({
  { "savq/paq-nvim" },
  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
  { 'williamboman/mason.nvim' },
  { 'williamboman/mason-lspconfig.nvim' },
  { 'neovim/nvim-lspconfig' },
  { 'rose-pine/neovim', as = 'rose-pine' },
  { "nvim-lua/plenary.nvim" },
  { "nvim-telescope/telescope.nvim", branch = "0.1.x" },
  { "tpope/vim-fugitive" },
})

-- [[ color theme ]]

function ColorMyPencils(color)
  color = color or "rose-pine"
  -- or vim.cmd("colorscheme rose-pine")
  vim.cmd.colorscheme(color)

  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

end

ColorMyPencils()

--  [[ treesitter config ]]

require('nvim-treesitter.configs').setup({
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" }
})

-- [[ telescope config ]]
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<leader>pg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>pb', builtin.buffers, {})
vim.keymap.set('n', '<leader>ph', builtin.help_tags, {})
vim.keymap.set('n', '<leader>ps', function()
  builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)

-- [[ lsp config ]]
require("mason").setup()
require("mason-lspconfig").setup()
require('lspconfig')['hls'].setup{
  filetypes = { 'haskell', 'lhaskell', 'cabal' },
  cmd = { "haskell-language-server-wrapper-2.9.0.1", "--lsp" },
}
require('lspconfig')['gopls'].setup{}
-- git commands (requires vim-fugitive)
-- vim.keymap.set("n", "<leader>gs", vim.cmd.Git('status'))
-- vim.keymap.set("n", "<leader>gs", vim.cmd("Git status")) 
