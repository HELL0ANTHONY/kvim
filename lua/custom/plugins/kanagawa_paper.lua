-- vim.cmd("colorscheme kanagawa-paper")
return {
  'thesimonho/kanagawa-paper.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('kanagawa-paper').setup {
      undercurl = true,
      transparent = false,
      gutter = false,
      dimInactive = true, -- disabled when transparent
      terminalColors = true,
      commentStyle = { italic = true },
      functionStyle = { italic = false },
      keywordStyle = { italic = false, bold = false },
      statementStyle = { italic = false, bold = false },
      typeStyle = { italic = false },
      colors = { theme = {}, palette = {} }, -- override default palette and theme colors
      overrides = function() -- override highlight groups
        return {}
      end,
    }
  end,
}
