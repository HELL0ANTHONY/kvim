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
        desc = '[w]orkspace jump to [l]ine',
      },
    }
  end,
  opts = {
    keys = 'etovxqpdygfblzhckisuran',
  },
}
