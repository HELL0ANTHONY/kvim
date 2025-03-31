return {
  'L3MON4D3/LuaSnip',
  config = function()
    local ls = require 'luasnip'
    local s = ls.snippet
    local i = ls.insert_node
    local f = ls.function_node

    ls.add_snippets('javascript', {
      s('plog', {
        f(function()
          local parent_dir = vim.fn.expand '%:h:t'
          local filename = vim.fn.expand '%:t'
          return "console.log('" .. parent_dir .. '/' .. filename .. "', { "
        end),
        i(1, 'variable'),
        f(function()
          return ' });'
        end),
      }),
    })

    ls.add_snippets('javascriptreact', {
      s('plog', {
        f(function()
          local parent_dir = vim.fn.expand '%:h:t'
          local filename = vim.fn.expand '%:t'
          return "console.log('" .. parent_dir .. '/' .. filename .. "', { "
        end),
        i(1, 'variable'),
        f(function()
          return ' });'
        end),
      }),
    })
  end,
}
