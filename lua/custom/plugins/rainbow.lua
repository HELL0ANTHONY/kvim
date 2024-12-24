-- https://gitlab.com/HiPhish/rainbow-delimiters.nvim
-- https://gitlab.com/HiPhish/rainbow-delimiters.nvim/-/blob/master/doc/rainbow-delimiters.txt
-- https://gitlab.com/HiPhish/rainbow-delimiters.nvim
local plugin = {
  'HiPhish/rainbow-delimiters.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
}

function plugin.config()
  local rainbow_delimiters = require 'rainbow-delimiters'

  -- Definir colores de manera programática
  local colors = {
    Blue = 'Blue',
    Cyan = 'Cyan',
    Green = 'Green',
    Orange = 'Orange',
    Red = 'Red',
    Violet = 'Violet',
    Yellow = 'Yellow',
  }

  for name, link in pairs(colors) do
    vim.cmd(('highlight link RainbowDelimiter%s %s'):format(name, link))
  end

  -- Configuración de estrategias y queries
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
      go = 'rainbow-parens',
    },
    highlight = vim.tbl_keys(colors),
  }
end

return plugin
