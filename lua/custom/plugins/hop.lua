return {
  'phaazon/hop.nvim',
  branch = 'v2',
  keys = function()
    return {
      {
        '<leader>ww',
        function()
          require('hop').hint_words()
        end,
        desc = '[w]orkspace: jump to [w]ord',
      },
      {
        '<leader>wl',
        function()
          require('hop').hint_lines()
        end,
        desc = '[w]orkspace: jump to [l]ine',
      },
      {
        '<leader>wW',
        function()
          require('hop').hint_words { multi_windows = true }
        end,
        desc = '[w]orkspace: jump to [W]ord (multi-window)',
      },
    }
  end,
  opts = {
    keys = 'etovxqpdygfblzhckisuran',
  },
}
