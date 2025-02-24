-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
-- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
vim.defer_fn(function()
  require('nvim-treesitter.configs').setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = { 'c', 'go', 'lua', 'python', 'rust', 'vimdoc', 'vim', 'bash', 'dockerfile', 'yaml' },

    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = { enable = true },
}
end, 0)
