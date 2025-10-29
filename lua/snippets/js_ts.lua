local ls = require 'luasnip'
local s, i, f = ls.snippet, ls.insert_node, ls.function_node

-- fábrica para crear el snippet (evita compartir estado entre FTs)
local function make_plog()
  return s('plog', {
    f(function()
      local parent_dir = vim.fn.expand '%:h:t'
      local filename = vim.fn.expand '%:t'
      return ("console.log('%s/%s', { "):format(parent_dir, filename)
    end),
    i(1, 'variable'),
    f(function()
      return ' });'
    end),
  })
end

-- exporta la fábrica y un helper para registrar en varios filetypes
local M = {}

function M.register(fts)
  for _, ft in ipairs(fts) do
    ls.add_snippets(ft, { make_plog() })
  end
end

return M
