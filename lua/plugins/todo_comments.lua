local icons = {
  FIX = ' ',
  HACK = ' ',
  IMPORTANT = ' ',
  NOTE = ' ',
  PERF = ' ',
  QUESTION = ' ',
  TEST = ' ',
  TODO = ' ',
  WARN = ' ',
}

local colors = {
  error = { 'DiagnosticError', 'ErrorMsg', '#fb4934' },
  warning = { 'DiagnosticWarn', 'WarningMsg', '#fabd2f' },
  info = { 'DiagnosticInfo', '#83a598' },
  important = { 'DiagnosticSignHint', '#fe8019' },
  hint = { 'DiagnosticHint', '#8ec07c' },
  default = { 'Identifier', '#d3869b' },
  test = { 'Special', '#b16286' },
  -- Orange = { 'Orange' },
  Orange = { '#fe8019' },
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
      IMPORTANT = { icon = icons.IMPORTANT, color = 'important' },
      HACK = { icon = icons.HACK, color = 'warning' },
      WARN = { icon = icons.WARN, color = 'warning', alt = { 'WARNING', 'XXX' } },
      PERF = { icon = icons.PERF, alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
      NOTE = { icon = icons.NOTE, color = 'hint', alt = { 'INFO' } },
      TEST = { icon = icons.TEST, color = 'test', alt = { 'TESTING', 'PASSED', 'FAILED' } },
      QUESTION = { icon = icons.QUESTION, color = 'Orange', alt = { 'Q' } },
    },

    gui_style = { fg = 'NONE', bg = 'BOLD' },
    merge_keywords = true,

    highlight = {
      multiline = false,
      multiline_pattern = '^.',
      multiline_context = 5,
      before = '',
      keyword = 'wide',
      after = 'fg',
      pattern = [[.*<(KEYWORDS)\s*:]],
      comments_only = true,
      max_line_len = 200,
    },

    colors = colors,

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
