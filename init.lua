-- author: joshua goldstein
-- license: MIT

-- [[ remappings ]]
-- see :h vim.g, :h mapleader, etc.
-- must happen before plugins are loaded (or wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-- file explorer
vim.keymap.set('n', '<leader>po', vim.cmd.Ex)
-- move around buffers
vim.keymap.set('n', '<S-l>', ':bnext<CR>')
vim.keymap.set('n', '<S-h>', ':bprevious<CR>')
-- resize with arrows
vim.keymap.set('n', '<C-Up>', ':resize +2<CR>')
vim.keymap.set('n', '<C-Down>', ':resize -2<CR>')
vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>')
vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>')
-- terminal emulator (see :h terminal-emulator)
vim.keymap.set('n', '<leader>t', ':terminal<CR>')
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')
-- center screen after jumping up / down
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')
-- shortcut to search open files
vim.keymap.set('', '<Space>', '<Nop>')
vim.keymap.set(
  'n', '<leader><space>', '<cmd>buffers<cr>:buffer ', { desc = 'Search open files' }
)
-- paste without clobbering register with deleted text
vim.keymap.set('x', '<leader>p', '\"_dP')

-- diagnostics
-- these are global because diagnostics are not exclusive to lsp servers
vim.keymap.set('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')

local ToggleDiagnostics = function()
  if vim.diagnostic.is_enabled() then
    vim.diagnostic.enable(false)
  else
    vim.diagnostic.enable()
  end
end
vim.keymap.set('n', '<leader>d', ToggleDiagnostics)


vim.diagnostic.config {
  virtual_text = false, -- instead use <C-w>d or gl to view diagnostic message under cursor
  signs = false, -- remove warning signs from sign column
  -- show float when jumping to diagnostics
  jump = {
    on_jump = function()
      vim.diagnostic.open_float()
    end,
  },
}

vim.diagnostic.enable(false) -- disable by default

-- [[editor options]]
-- equivalent to :set number, etc.
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
vim.opt.laststatus = 2
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

-- [[ packages ]]
-- from https://echasnovski.com/blog/2026-03-13-a-guide-to-vim-pack
-- this will eventually not be needed
vim.api.nvim_create_autocmd('PackChanged', { callback = function(ev)
  local name, kind = ev.data.spec.name, ev.data.kind
  if name == 'nvim-treesitter' and kind == 'update' then
    if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
    vim.cmd('TSUpdate')
  end
end })

vim.pack.add({
  { src = "https://github.com/rose-pine/neovim", name = "rose-pine", },
  -- requires https://formulae.brew.sh/formula/tree-sitter-cli
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", },
  { src = "https://github.com/nvim-lua/plenary.nvim", },
  { src = "https://github.com/nvim-telescope/telescope.nvim", },
  -- { src = 'https://github.com/mrcjkb/haskell-tools.nvim', version = vim.version.range('^10') },
})

-- [[ colorscheme ]]
require('rose-pine').setup({
  styles = {
    bold = false,
    italic = false,
    transparency = true,
  }
})
vim.cmd.colorscheme('rose-pine')
vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })

-- [[ treesitter ]]
-- :h nvim-treesitter-commands
-- docs https://tree-sitter.github.io/tree-sitter/
require('nvim-treesitter').install({
  'c', 'lua', 'vim', 'vimdoc', 'query',
  'markdown', 'markdown_inline', 'go', 'javascript',
  'java', 'haskell', 'python',
})

local parsersInstalled = require("nvim-treesitter").get_installed('parsers')
for _, parser in pairs(parsersInstalled) do
  local filetypes = vim.treesitter.language.get_filetypes(parser)
  vim.api.nvim_create_autocmd('FileType', {
    pattern = filetypes,
    callback = function()
      vim.treesitter.start()
      vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      vim.wo[0][0].foldmethod = 'expr'
      vim.wo.foldlevel = 99
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
  })
end

-- [[ telescope ]]
local actions_layout = require('telescope.actions.layout')
require('telescope').setup({
  defaults = {
    mappings = {
      n = { ['<C-o>'] = actions_layout.toggle_preview },
      i = { ['<C-o>'] = actions_layout.toggle_preview }
    },
    preview = {
      hide_on_startup = true
    }
  },
})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<leader>pg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>pb', builtin.buffers, {})
vim.keymap.set('n', '<leader>ph', builtin.help_tags, {})
vim.keymap.set('n', '<leader>ps', function()
  builtin.grep_string { search = vim.fn.input 'Grep > ' }
end)

-- [[ lsp ]]
-- lsp configs live in ~/.config/lsp and must be enabled individually
-- default configurations found at:
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
-- see :h lsp, lsp-defaults, and lsp-config, diagnostic-defaults
vim.lsp.enable({
  "haskell-language-server",
  "lua-language-server",
})

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

-- https://github.com/mfussenegger/nvim-dap
-- https://codeberg.org/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
