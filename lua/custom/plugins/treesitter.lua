return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  main = 'nvim-treesitter.configs',

  opts = {
    ensure_installed = { 'typoscript', 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'query', 'vim', 'vimdoc' },

    auto_install = true,
    highlight = {
      enable = true,

      additional_vim_regex_highlighting = { 'ruby' },
    },
    indent = { enable = true, disable = { 'ruby', 'markdown', 'markdown_inline' } },
  },

  -- config = function()
  --   if vim.fn.has 'win32' == 1 then
  --     require('nvim-treesitter.install').compilers = { 'clang' }
  --   end
  -- end,
}
