-- author: joshua goldstein
-- license: MIT

-- [[ remappings ]]
-- see :h vim.g, :h mapleader, etc.
-- must happen before plugins are loaded (or wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-- file explorer
vim.keymap.set('n', '<leader>pp', vim.cmd.Ex)
-- move around buffers
vim.keymap.set('n', '<S-l>', ':bnext<CR>')
vim.keymap.set('n', '<S-h>', ':bprevious<CR>')
-- resize with arrows
vim.keymap.set('n', '<C-Up>', ':resize +2<CR>')
vim.keymap.set('n', '<C-Down>', ':resize -2<CR>')
vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>')
vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>')
-- use esc to exit terminal mode
-- see :help terminal-emulator
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')
-- center screen after jumping up / down
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')
-- shortcut to search open files
vim.keymap.set('', '<Space>', '<Nop>')
vim.keymap.set('n', '<leader><space>', '<cmd>buffers<cr>:buffer ', { desc = 'Search open files' })

-- diagnostics are not exclusive to lsp servers
-- so these can be global keybindings
vim.keymap.set('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')
vim.keymap.set('n', '<leader>d', '<cmd>lua ToggleDiagnostics()<cr>')

function ToggleDiagnostics()
  if vim.diagnostic.is_enabled() then
    vim.diagnostic.enable(false)
  else
    vim.diagnostic.enable()
  end
end

vim.diagnostic.config {
  virtual_text = false, -- instead use <C-w>d or gl to view diagnostic message under cursor
  signs = false, -- remove warning signs from sign column
--  jump = { float = true } -- show float when jumping to diagnostics
}

-- disable diagnostics by default
vim.diagnostic.enable(false)

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
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[ package manager ]]
-- clone paq if not already present
local clone_paq = function()
  local path = vim.fn.stdpath 'data' .. '/site/pack/paqs/start/paq-nvim'
  local is_installed = vim.fn.empty(vim.fn.glob(path)) == 0
  if not is_installed then
    vim.fn.system { 'git', 'clone', '--depth=1', 'https://github.com/savq/paq-nvim.git', path }
    return true
  end
end

local bootstrap_paq = function(packages)
  vim.cmd.packadd 'paq-nvim'
  local paq = require 'paq'
  paq(packages)
  paq.install()
end

local setup_paq = function(packages)
  local first_install = clone_paq()
  if not first_install then
    local paq = require 'paq'
    paq(packages)
  else
    bootstrap_paq(packages)
  end
end

setup_paq {
  { 'savq/paq-nvim' },
  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
  { 'mason-org/mason.nvim' },
--  { 'mason-org/mason-lspconfig.nvim' },
  { 'neovim/nvim-lspconfig' },
  { 'mhartington/formatter.nvim' },
  { 'mfussenegger/nvim-lint' },
  { 'rose-pine/neovim', as = 'rose-pine' },
  { 'nvim-lua/plenary.nvim' },
  { 'nvim-telescope/telescope.nvim', branch = '0.1.x' },
  { 'tpope/vim-fugitive' },
}

-- [[ colorscheme ]]
function ColorMyPencils(color)
  color = color or 'rose-pine'
  -- or vim.cmd("colorscheme rose-pine")
  vim.cmd.colorscheme(color)
  vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
end
ColorMyPencils()

--  [[ treesitter ]]
require('nvim-treesitter.configs').setup {
  ensure_installed = { 'c', 'lua', 'vim', 'vimdoc', 'query', 'markdown', 'markdown_inline' },
}

-- [[ telescope ]]
local builtin = require 'telescope.builtin'
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<leader>pg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>pb', builtin.buffers, {})
vim.keymap.set('n', '<leader>ph', builtin.help_tags, {})
vim.keymap.set('n', '<leader>ps', function()
  builtin.grep_string { search = vim.fn.input 'Grep > ' }
end)

-- [[ lsp ]]
-- see :h lsp and :h lsp-defaults and :h lsp-config
-- see :h lspconfig and :h lspconfig-all for info about default configurations (from nvim-lspconfig)
require('mason').setup()
-- require('mason-lspconfig').setup()

-- configs here will overwrite lspconfig defaults
vim.lsp.config('hls', {
  filetypes = { 'haskell', 'lhaskell', 'cabal' },
  cmd = { 'haskell-language-server-wrapper-2.9.0.1', '--lsp' },
})

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' }
      }
    }
  }
})

vim.lsp.enable('hls')
vim.lsp.enable('gopls')
vim.lsp.enable('lua_ls')
vim.lsp.enable('pylsp')

-- ref: https://vonheikemen.github.io/devlog/tools/neovim-lsp-client-guide/
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(event)
    local bufmap = function(mode, rhs, lhs)
      vim.keymap.set(mode, rhs, lhs, {buffer = event.buf})
    end

    -- These keymaps are the defaults in Neovim v0.11
    -- see :h lsp-default
    -- bufmap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')
    -- bufmap('n', 'grr', '<cmd>lua vim.lsp.buf.references()<cr>')
    -- bufmap('n', 'gri', '<cmd>lua vim.lsp.buf.implementation()<cr>')
    -- bufmap('n', 'grn', '<cmd>lua vim.lsp.buf.rename()<cr>')
    -- bufmap('n', 'gra', '<cmd>lua vim.lsp.buf.code_action()<cr>')
    -- bufmap('n', 'gO', '<cmd>lua vim.lsp.buf.document_symbol()<cr>')
    -- bufmap({'i', 's'}, '<C-s>', '<cmd>lua vim.lsp.buf.signature_help()<cr>')
    -- see also: ctrl-] (jump to definition, ctrl-t or ctrl-o to go back)
    -- see also: ctrl-x ctrl-o in insert mode to trigger code completions
    -- see also: ctrl-w + d for floating window diagnostics, ]d and [d to move between diagnostics
    -- see also: gq for formatting

    -- These are custom keymaps
    -- bufmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')
    bufmap('n', 'grt', '<cmd>lua vim.lsp.buf.type_definition()<cr>')
    bufmap('n', 'grd', '<cmd>lua vim.lsp.buf.declaration()<cr>')
    -- bufmap({'n', 'x'}, 'gq', '<cmd>lua vim.lsp.buf.format({async = true})<cr>')
  end,
})

-- [[ formatter ]]
-- configure Format, FormatWrite, FormatLock, and FormatWriteLock commands
require('formatter').setup {
  logging = true,
  log_level = vim.log.levels.WARN,
  -- All formatter configurations are opt-in
  filetype = {
    -- formatters are executed in order within their own tables
    css = {
      require 'formatter.defaults.prettier',
    },
    html = {
      require 'formatter.defaults.prettier',
    },
    lua = {
      require('formatter.filetypes.lua').stylua,
    },
    -- any filetype
    ['*'] = {
      require('formatter.filetypes.any').remove_trailing_whitespace,
      -- Remove trailing whitespace without 'sed'
      -- require("formatter.filetypes.any").substitute_trailing_whitespace,
    },
  },
}

-- [[ linter ]]
require('lint').linters_by_ft = {
  lua = { 'luacheck' },
}
vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
  callback = function()
    require('lint').try_lint()
  end,
})

-- [[ misc ]]
-- git commands (requires vim-fugitive)
-- vim.keymap.set("n", "<leader>gs", vim.cmd.Git('status'))
-- vim.keymap.set("n", "<leader>gs", vim.cmd("Git status"))
--
