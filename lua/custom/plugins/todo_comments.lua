local icons = {
  FIX = ' ',
  TODO = ' ',
  HACK = ' ',
  WARN = ' ',
  PERF = ' ',
  NOTE = ' ',
  TEST = '󰙨 ',
}

local colors = {
  error = { 'DiagnosticVirtualTextError', 'ErrorMsg', '#fb4934' },
  warning = { 'DiagnosticVirtualTextWarn', 'WarningMsg', '#fabd2f' },
  info = { 'DiagnosticVirtualTextInfo', '#83a598' },
  hint = { 'DiagnosticVirtualTextHint', '#8ec07c' },
  default = { 'Identifier', '#d3869b' },
  test = { 'Identifier', '#b16286' },
}

return {
  'folke/todo-comments.nvim',
  event = 'VimEnter',
  dependencies = { 'nvim-lua/plenary.nvim' },

  opts = {
    signs = true,
    sign_priority = 8,

    keywords = {
      FIX = { icon = icons.FIX, color = 'error', alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE' } },
      TODO = { icon = icons.TODO, color = 'info' },
      HACK = { icon = icons.HACK, color = 'warning' },
      WARN = { icon = icons.WARN, color = 'warning', alt = { 'WARNING', 'XXX' } },
      PERF = { icon = icons.PERF, alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
      NOTE = { icon = icons.NOTE, color = 'hint', alt = { 'INFO' } },
      TEST = { icon = icons.TEST, color = 'test', alt = { 'TESTING', 'PASSED', 'FAILED' } },
    },

    gui_style = { fg = 'NONE', bg = 'BOLD' },
    merge_keywords = true,

    highlight = {
      multiline = false, -- Puedes cambiar esto a true si usas multilínea
      multiline_pattern = '^.',
      multiline_context = 5, -- Ajustado para menos contexto si no es necesario
      before = '',
      keyword = 'wide',
      after = 'fg',
      pattern = [[.*<(KEYWORDS)\s*:]],
      comments_only = true,
      max_line_len = 200,
    },

    colors = colors, -- Usando la variable local para colores

    search = {
      command = 'rg',
      args = {
        '--color=never',
        '--no-heading',
        '--with-filename',
        '--line-number',
        '--column',
      },
      pattern = [[\b(KEYWORDS):]],
    },
  },
}
