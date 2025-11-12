-- local ls = require 'luasnip'
-- local s, i, f = ls.snippet, ls.insert_node, ls.function_node
--
-- -- fábrica para crear el snippet (evita compartir estado entre FTs)
-- local function make_plog()
--   return s('plog', {
--     f(function()
--       local parent_dir = vim.fn.expand '%:h:t'
--       local filename = vim.fn.expand '%:t'
--       return ("console.log('%s/%s', { "):format(parent_dir, filename)
--     end),
--     i(1, 'variable'),
--     f(function()
--       return ' });'
--     end),
--   })
-- end
--
-- -- exporta la fábrica y un helper para registrar en varios filetypes
-- local M = {}
--
-- function M.register(fts)
--   for _, ft in ipairs(fts) do
--     ls.add_snippets(ft, { make_plog() })
--   end
-- end
--
-- return M

local ls = require 'luasnip'
local s, i, f = ls.snippet, ls.insert_node, ls.function_node

-- Helper para obtener "carpeta/archivo"
local function file_path()
  local parent_dir = vim.fn.expand '%:h:t'
  local filename = vim.fn.expand '%:t'
  return ('%s/%s'):format(parent_dir, filename)
end

-- Fábrica genérica
local function make_console_snippet(key, method, extra)
  return s(key, {
    f(function()
      local path = file_path()
      local base = ("console.%s('%s'"):format(method, path)
      if extra and extra.before then
        base = base .. extra.before
      end
      return base
    end),
    i(1, 'variable'),
    f(function()
      local after = ''
      if extra and extra.after then
        after = extra.after
      end
      return after
    end),
  })
end

-- Snippet específico para console.count con template string
local function make_pct()
  return s('pct', {
    f(function()
      local path = file_path()
      return ('console.count(`%s → count: ${'):format(path)
    end),
    i(1, 'variable'),
    f(function()
      return '}`);'
    end),
  })
end

-- Otros snippets
local function make_plog()
  return make_console_snippet('plog', 'log', {
    before = ', { ',
    after = ' });',
  })
end

local function make_pwrn()
  return make_console_snippet('pwrn', 'warn', {
    before = ', { ',
    after = ' });',
  })
end

local function make_perr()
  return make_console_snippet('perr', 'error', {
    before = ', { ',
    after = ' });',
  })
end

local function make_ptbl()
  return make_console_snippet('ptbl', 'table', {
    before = ', ',
    after = ');',
  })
end

-- Exporta todo
local M = {}

function M.register(fts)
  for _, ft in ipairs(fts) do
    ls.add_snippets(ft, {
      make_plog(),
      make_pct(),
      make_pwrn(),
      make_perr(),
      make_ptbl(),
    })
  end
end

return M
