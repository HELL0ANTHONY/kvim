local ls = require('luasnip')
local s = ls.snippet
local i = ls.insert_node
local fmt = require('luasnip.extras.fmt').fmt

local function make_snippets()
  return {
    -- resource
    s('res', fmt([[
resource "{}" "{}" {{
  {}
}}]], { i(1, 'type'), i(2, 'name'), i(3) })),

    -- module
    s('mod', fmt([[
module "{}" {{
  source = "{}"

  {}
}}]], { i(1, 'name'), i(2, 'source'), i(3) })),

    -- variable
    s('var', fmt([[
variable "{}" {{
  description = "{}"
  type        = {}
  default     = {}
}}]], { i(1, 'name'), i(2, 'description'), i(3, 'string'), i(4) })),

    -- output
    s('out', fmt([[
output "{}" {{
  description = "{}"
  value       = {}
}}]], { i(1, 'name'), i(2, 'description'), i(3) })),

    -- data source
    s('data', fmt([[
data "{}" "{}" {{
  {}
}}]], { i(1, 'type'), i(2, 'name'), i(3) })),

    -- locals
    s('loc', fmt([[
locals {{
  {} = {}
}}]], { i(1, 'key'), i(2, 'value') })),

    -- provider
    s('prov', fmt([[
provider "{}" {{
  {}
}}]], { i(1, 'name'), i(2) })),
  }
end

local M = {}

function M.register()
  -- terraform (.tf) y hcl (.hcl, terragrunt)
  for _, ft in ipairs({ 'terraform', 'hcl' }) do
    ls.add_snippets(ft, make_snippets())
  end
end

return M
