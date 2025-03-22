local ls = require 'luasnip'
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node

ls.add_snippets('javascript', {
  s('plog', {
    f(function()
      return "console.log('" .. vim.fn.expand '%:t' .. "', { "
    end),
    i(1, 'variable'),
    f(function()
      return ' });'
    end),
  }),
})
