-- ── Indentación Python (PEP 8) ─────────────────────────────────────────────
vim.opt_local.expandtab    = true
vim.opt_local.shiftwidth   = 4
vim.opt_local.tabstop      = 4
vim.opt_local.softtabstop  = 4
vim.opt_local.colorcolumn  = "88"   -- ruff default line length

-- ── indent-blankline: background color guides (solo para Python) ────────────
local ok, ibl = pcall(require, "ibl")
if not ok then return end

local function set_py_ibl_hls()
  -- Fondos sutiles alternados sobre la paleta gruvbox-material dark
  -- bg base: #282828 → niveles impares ligeramente más cálidos/claros
  vim.api.nvim_set_hl(0, "PyIBLOdd",   { bg = "#2d2b2b" })
  vim.api.nvim_set_hl(0, "PyIBLEven",  { bg = "#332f2f" })
  vim.api.nvim_set_hl(0, "PyIBLScope", { bg = "#3a3632" })
end

set_py_ibl_hls()

-- Re-aplicar si cambia el colorscheme estando en un buffer Python
vim.api.nvim_create_autocmd("ColorScheme", {
  buffer   = 0,
  callback = set_py_ibl_hls,
})

-- Configuración por buffer: sin carácter, solo fondos alternados
ibl.setup_buffer(0, {
  indent = {
    char      = "",   -- sin línea vertical, solo el fondo
    highlight = { "PyIBLOdd", "PyIBLEven" },
    smart_indent_cap = true,
  },
  scope = {
    enabled    = true,
    show_start = false,
    show_end   = false,
    highlight  = { "PyIBLScope" },
  },
})
