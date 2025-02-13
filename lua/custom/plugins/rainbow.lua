-- https://gitlab.com/HiPhish/rainbow-delimiters.nvim
-- https://gitlab.com/HiPhish/rainbow-delimiters.nvim/-/blob/master/doc/rainbow-delimiters.txt
-- https://gitlab.com/HiPhish/rainbow-delimiters.nvim

local plugin = {
  'HiPhish/rainbow-delimiters.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
}

function plugin.config()
  local ok, rainbow_delimiters = pcall(require, 'rainbow-delimiters')
  if not ok then
    return
  end

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

  local rainbow_parens = 'rainbow-parens'

  vim.g.rainbow_delimiters = {
    strategy = {
      [''] = rainbow_delimiters.strategy['global'],
      vim = rainbow_delimiters.strategy['local'],
    },
    query = {
      [''] = 'rainbow-delimiters',
      lua = 'rainbow-blocks',
      go = rainbow_parens,
      html = rainbow_parens,
      typescript = rainbow_parens,
      javascript = rainbow_parens,
      typescriptreact = rainbow_parens,
      javascriptreact = rainbow_parens,
      tsx = rainbow_parens,
      jsx = rainbow_parens,
    },
    highlight = vim.tbl_keys(colors),
  }
end

return plugin
