return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  main = 'nvim-treesitter.configs',
  opts = {
    ensure_installed = (function()
      return {
        'bash',
        'c',
        'diff',
        'go',
        'gomod',
        'gosum',
        'gowork',
        'hcl',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'powershell',
        'query',
        'terraform',
        'vim',
        'vimdoc',
      }
    end)(), -- Envuelto en una función anónima para evitar evaluar la tabla en cada carga
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = { 'ruby' },
    },
    indent = {
      enable = true,
      disable = { 'ruby' },
    },
  },

  -- config = function()
  --   if vim.fn.has 'win32' == 1 then
  --     require('nvim-treesitter.install').compilers = { 'clang' } -- Usar 'gcc' si clang no está disponible
  --   end
  -- end,
}
