-- ── Indentación Python (PEP 8) ─────────────────────────────────────────────
vim.opt_local.expandtab   = true
vim.opt_local.shiftwidth  = 4
vim.opt_local.tabstop     = 4
vim.opt_local.softtabstop = 4
vim.opt_local.colorcolumn = "88"

-- ── indent-blankline: background color guides ───────────────────────────────
local ok, ibl = pcall(require, "ibl")
if not ok then return end

local function set_py_ibl_hls()
  -- Dos fondos alternados sobre gruvbox-material dark (#282828)
  -- Suficientemente distintos para ser visibles pero sin romper la paleta
  vim.api.nvim_set_hl(0, "PyIBLOdd",   { bg = "#2e2b2b" }) -- nivel impar
  vim.api.nvim_set_hl(0, "PyIBLEven",  { bg = "#353030" }) -- nivel par (más claro)
  vim.api.nvim_set_hl(0, "PyIBLScope", { bg = "#3d3835" }) -- scope activo
end

set_py_ibl_hls()
vim.api.nvim_create_autocmd("ColorScheme", {
  buffer   = 0,
  callback = set_py_ibl_hls,
})

ibl.setup_buffer(0, {
  indent = {
    char      = "",  -- sin carácter, solo el fondo
    highlight = { "PyIBLOdd", "PyIBLEven" },
    smart_indent_cap = true,
  },
  -- whitespace es lo que rellena el área completa con el color de fondo
  whitespace = {
    highlight          = { "PyIBLOdd", "PyIBLEven" },
    remove_blankline_trail = false,
  },
  scope = {
    enabled    = true,
    show_start = false,
    show_end   = false,
    highlight  = { "PyIBLScope" },
  },
})
