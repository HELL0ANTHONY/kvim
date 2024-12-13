-- https://gitlab.com/HiPhish/rainbow-delimiters.nvim
-- https://gitlab.com/HiPhish/rainbow-delimiters.nvim/-/blob/master/doc/rainbow-delimiters.txt
-- https://gitlab.com/HiPhish/rainbow-delimiters.nvim
local plugin = {
  'HiPhish/rainbow-delimiters.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
}

function plugin.config()
  local rainbow_delimiters = require 'rainbow-delimiters'

  vim.cmd [[
      highlight link RainbowDelimiterBlue Blue
      highlight link RainbowDelimiterCyan Cyan
      highlight link RainbowDelimiterGreen Green
      highlight link RainbowDelimiterOrange  Orange
      highlight link RainbowDelimiterRed Red
      highlight link RainbowDelimiterViolet Violet
      highlight link RainbowDelimiterYellow Yellow
    ]]

  vim.g.rainbow_delimiters = {
    strategy = {
      [''] = rainbow_delimiters.strategy['global'],
      vim = rainbow_delimiters.strategy['local'],
    },
    query = {
      [''] = 'rainbow-delimiters',
      lua = 'rainbow-blocks',
      typescript = 'rainbow-parens',
      javascript = 'rainbow-parens',
      typescriptreact = 'rainbow-parens',
      javascriptreact = 'rainbow-parens',
      tsx = 'rainbow-parens',
      jsx = 'rainbow-parens',
      html = 'rainbow-parens',
    },
    highlight = {
      'RainbowDelimiterBlue',
      'RainbowDelimiterCyan',
      'RainbowDelimiterGreen',
      'RainbowDelimiterOrange',
      'RainbowDelimiterRed',
      'RainbowDelimiterViolet',
      'RainbowDelimiterYellow',
    },
  }
end

return plugin
