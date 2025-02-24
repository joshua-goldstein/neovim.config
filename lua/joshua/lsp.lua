-- LANGUAGE SERVER CONFIG --
-- taken from https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/configuration-templates.md#primes-config
local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({
    buffer = bufnr,
    preserve_mappings = false,     -- clobber existing keymappings
  })
end)

require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {},
  handlers = {
    lsp_zero.default_setup,
    -- from https://github.com/golang/tools/blob/master/gopls/doc/vim.md#neovim
    gopls = function()
      require('lspconfig').gopls.setup({
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
            },
            staticcheck = true,
            gofumpt = true,
          },
        },
      })
    end,
  }
})

-- AUTOCOMPLETE --
-- ref: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/autocomplete.md#use-enter-to-confirm-completion
-- templates: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/configuration-templates.md
local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()

cmp.setup({
  completion = {
    autocomplete = false
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
    ['<Tab>'] = cmp_action.tab_complete(),
    ['<S-Tab>'] = cmp_action.select_prev_or_fallback(),
    ['<C-k>'] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item({ behavior = 'insert' })
      else
        cmp.complete()
      end
    end),
    ['<C-j>'] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_next_item({ behavior = 'insert' })
      else
        cmp.complete()
      end
    end),
  })
})
