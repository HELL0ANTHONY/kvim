return {
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local ibl   = require("ibl")
      local hooks = require("ibl.hooks")

      -- Hook ACTIVE: ibl solo se activa en buffers Python
      hooks.register(hooks.type.ACTIVE, function(bufnr)
        return vim.bo[bufnr].filetype == "python"
      end)

      -- Config: background color guides (referencia oficial)
      local highlight = { "CursorColumn", "Whitespace" }
      ibl.setup({
        indent = {
          highlight        = highlight,
          char             = "",
          smart_indent_cap = true,
        },
        whitespace = {
          highlight              = highlight,
          remove_blankline_trail = false,
        },
        scope   = { enabled = false },
        exclude = {
          buftypes = { "terminal", "nofile", "quickfix", "prompt" },
        },
      })
    end,
  },
}
