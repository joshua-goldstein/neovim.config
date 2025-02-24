
-- can bootstrap paq
-- see :help paq-bootstrapping
require "paq" {
    { 'savq/paq-nvim' }, -- let paq manage itself
    { 'rose-pine/neovim', as = 'rose-pine' }, -- theme
    -- lsp-zero and its dependencies 
    {'VonHeikemen/lsp-zero.nvim', branch = 'v3.x'},
    -- we will manage lsp servers from neovim
    {'williamboman/mason.nvim'},
    {'williamboman/mason-lspconfig.nvim'},
    -- LSP Support
    {'neovim/nvim-lspconfig'};
    -- Autocompletion
    {'hrsh7th/nvim-cmp'};
    {'hrsh7th/cmp-nvim-lsp'};
    {'L3MON4D3/LuaSnip'};
    -- treesitter
    {"nvim-treesitter/nvim-treesitter", build = 'TSUpdate'},
    -- telescope
    { 'nvim-lua/plenary.nvim' },
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make'},
    { 'nvim-telescope/telescope.nvim', branch='0.1.x'},
}
