return {
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPre", "BufNewFile" },
    opts = function()
      -- "Background color indentation guides" — config exacto de la referencia oficial.
      -- CursorColumn: bg = ~#32302f en gruvbox-material (visible sobre #282828)
      -- Whitespace:   solo fg → transparente → alternancia visible/invisible por nivel
      local highlight = { "CursorColumn", "Whitespace" }

      return {
        indent = {
          highlight        = highlight,
          char             = "",   -- sin carácter, solo el fondo del highlight
          smart_indent_cap = true,
        },
        whitespace = {
          highlight              = highlight,
          remove_blankline_trail = false,
        },
        scope = { enabled = false },
        exclude = {
          filetypes = {
            "help", "alpha", "dashboard", "neo-tree", "Trouble",
            "trouble", "lazy", "mason", "notify", "oil",
          },
          buftypes = { "terminal", "nofile", "quickfix", "prompt" },
        },
      }
    end,
  },
}
