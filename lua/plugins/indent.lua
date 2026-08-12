return {
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local ibl = require("ibl")
      local hooks = require("ibl.hooks")

      -- Highlight groups para los dos niveles alternados (gruvbox-material)
      local function set_hls()
        -- CursorColumn tiene bg = ~#32302f en gruvbox-material (visible sobre #282828)
        -- Whitespace solo tiene fg → transparente → efecto de "columna visible / no visible"
        -- Para Python usamos colores propios más saturados
        vim.api.nvim_set_hl(0, "PyIBLOdd",   { bg = "#2e2b2b" })
        vim.api.nvim_set_hl(0, "PyIBLEven",  { bg = "#353030" })
        vim.api.nvim_set_hl(0, "PyIBLScope", { bg = "#3d3835" })
      end
      set_hls()
      hooks.register(hooks.type.HIGHLIGHT_SETUP, set_hls)

      -- Config global: carácter │ para todos los filetypes
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

      -- Python: background color guides via setup() con exclude de todo lo demás
      -- Se usa un autocmd FileType que llama setup_buffer justo después de que
      -- ibl termina de procesar el buffer por primera vez (via vim.schedule)
      vim.api.nvim_create_autocmd("FileType", {
        pattern  = "python",
        callback = function(ev)
          local buf = ev.buf
          vim.schedule(function()
            if not vim.api.nvim_buf_is_valid(buf) then return end
            ibl.setup_buffer(buf, {
              indent = {
                char             = "",
                highlight        = { "PyIBLOdd", "PyIBLEven" },
                smart_indent_cap = true,
              },
              whitespace = {
                highlight              = { "PyIBLOdd", "PyIBLEven" },
                remove_blankline_trail = false,
              },
              scope = {
                enabled    = true,
                show_start = false,
                show_end   = false,
                highlight  = { "PyIBLScope" },
              },
            })
          end)
        end,
      })
    end,
  },
}
