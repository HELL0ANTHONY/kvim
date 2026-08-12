return {
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local ibl = require("ibl")

      -- Highlights para el modo background de Python
      local function set_python_hls()
        vim.api.nvim_set_hl(0, "PyIBLOdd",   { bg = "#2e2b2b" })
        vim.api.nvim_set_hl(0, "PyIBLEven",  { bg = "#353030" })
        vim.api.nvim_set_hl(0, "PyIBLScope", { bg = "#3d3835" })
      end
      set_python_hls()
      vim.api.nvim_create_autocmd("ColorScheme", { callback = set_python_hls })

      -- Config global: guía con carácter │ para todos los filetypes
      ibl.setup({
        indent = {
          char             = "│",
          smart_indent_cap = true,
        },
        scope = {
          enabled    = true,
          show_start = false,
          show_end   = false,
        },
        exclude = {
          filetypes = {
            "help", "alpha", "dashboard", "neo-tree", "Trouble",
            "trouble", "lazy", "mason", "notify", "oil",
          },
          buftypes = { "terminal", "nofile", "quickfix", "prompt" },
        },
      })

      -- Python: background color guides (override por buffer)
      vim.api.nvim_create_autocmd("FileType", {
        pattern  = "python",
        callback = function(ev)
          ibl.setup_buffer(ev.buf, {
            indent = {
              char             = "",
              highlight        = { "PyIBLOdd", "PyIBLEven" },
              smart_indent_cap = true,
            },
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
        end,
      })
    end,
  },
}
