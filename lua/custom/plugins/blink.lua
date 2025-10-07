return {
  {
    'saghen/blink.cmp',
    version = '*',
    event = { 'InsertEnter', 'CmdlineEnter' },
    dependencies = {
      'rafamadriz/friendly-snippets',
      'L3MON4D3/LuaSnip',
    },
    opts = {
      keymap = {
        preset = 'super-tab',
        ['<C-j>'] = { 'select_next', 'fallback' },
        ['<C-k>'] = { 'select_prev', 'fallback' },
        ['<CR>'] = { 'accept', 'fallback' },
      },
      signature = { enabled = true },
      appearance = { use_nvim_cmp_as_default = true },
      sources = {
        default = { 'lsp', 'path', 'buffer', 'snippets' },
      },
    },
    config = function(_, opts)
      require('blink.cmp').setup(opts)
      require('luasnip.loaders.from_vscode').lazy_load()
    end,
  },
}
