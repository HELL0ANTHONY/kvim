local ls = require('luasnip')
local s = ls.snippet
local i = ls.insert_node
local rep = require('luasnip.extras').rep
local fmt = require('luasnip.extras.fmt').fmt

local function make_snippets()
  return {
    -- if err != nil { return err }
    s('iferr', fmt([[
if err != nil {{
	return {}
}}]], { i(1, 'err') })),

    -- if err != nil { return fmt.Errorf(...) }
    s('iferrf', fmt([[
if err != nil {{
	return fmt.Errorf("{}: %w", err)
}}]], { i(1, 'context') })),

    -- fmt.Println
    s('pln', fmt([[fmt.Println({})]], { i(1) })),

    -- fmt.Printf
    s('pf', fmt([[fmt.Printf("{}\n", {})]], { i(1, 'format'), i(2) })),

    -- fmt.Errorf
    s('errf', fmt([[fmt.Errorf("{}: %w", {})]], { i(1, 'context'), i(2, 'err') })),

    -- struct
    s('st', fmt([[
type {} struct {{
	{}
}}]], { i(1, 'Name'), i(2) })),

    -- interface
    s('iface', fmt([[
type {} interface {{
	{}
}}]], { i(1, 'Name'), i(2) })),

    -- test function
    s('test', fmt([[
func Test{}(t *testing.T) {{
	{}
}}]], { i(1, 'Name'), i(2) })),

    -- table-driven test
    s('tbl', fmt([[
func Test{}(t *testing.T) {{
	tests := []struct {{
		name string
		{}
	}}{{
		{{
			name: "{}",
			{}
		}},
	}}

	for _, tt := range tests {{
		t.Run(tt.name, func(t *testing.T) {{
			{}
		}})
	}}
}}]], { i(1, 'Name'), i(2, 'fields'), i(3, 'case'), i(4), i(5) })),

    -- benchmark
    s('bench', fmt([[
func Benchmark{}(b *testing.B) {{
	for i := 0; i < b.N; i++ {{
		{}
	}}
}}]], { i(1, 'Name'), i(2) })),

    -- goroutine
    s('gor', fmt([[
go func() {{
	{}
}}()]], { i(1) })),
  }
end

local M = {}

function M.register()
  ls.add_snippets('go', make_snippets())
end

return M
