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
local rep = require('luasnip.extras').rep
local fmt = require('luasnip.extras.fmt').fmt

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
      return ('console.count(`%s → count: ${"'):format(path)
    end),
    i(1, 'variable'),
    f(function()
      return '"}`);'
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

-- React: functional component
local function make_rfc()
  return s('rfc', fmt([[
function {}() {{
  return (
    <div>
      {}
    </div>
  )
}}

export default {}]], { i(1, 'Component'), i(2), rep(1) }))
end

-- React: useState
local function make_ust()
  return s('ust', fmt([[const [{}, set{}] = useState({})]], {
    i(1, 'state'),
    rep(1),
    i(2),
  }))
end

-- React: useEffect
local function make_uef()
  return s('uef', fmt([[
useEffect(() => {{
  {}
}}, [{}])]], { i(1), i(2) }))
end

-- React: useCallback
local function make_ucb()
  return s('ucb', fmt([[
const {} = useCallback(() => {{
  {}
}}, [{}])]], { i(1, 'cb'), i(2), i(3) }))
end

-- React: useMemo
local function make_umm()
  return s('umm', fmt([[
const {} = useMemo(() => {{
  return {}
}}, [{}])]], { i(1, 'value'), i(2), i(3) }))
end

-- React: useRef
local function make_urf()
  return s('urf', fmt([[const {} = useRef({})]], { i(1, 'ref'), i(2, 'null') }))
end

-- Next.js: page component (app router)
local function make_npage()
  return s('npage', fmt([[
export default function {}() {{
  return (
    <main>
      {}
    </main>
  )
}}]], { i(1, 'Page'), i(2) }))
end

-- Next.js: layout component
local function make_nlay()
  return s('nlay', fmt([[
export default function {}({{ children }}: {{ children: React.ReactNode }}) {{
  return (
    <div>
      {{children}}
    </div>
  )
}}]], { i(1, 'Layout') }))
end

-- Next.js: server action
local function make_nact()
  return s('nact', fmt([[
'use server'

export async function {}({}) {{
  {}
}}]], { i(1, 'action'), i(2), i(3) }))
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
      make_rfc(),
      make_ust(),
      make_uef(),
      make_ucb(),
      make_umm(),
      make_urf(),
      make_npage(),
      make_nlay(),
      make_nact(),
    })
  end
end

return M
