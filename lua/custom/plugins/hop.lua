return {
  'phaazon/hop.nvim',
  branch = 'v2',
  keys = function()
    return {
      {
        '\\',
        function()
          require('hop').hint_words()
        end,
        desc = 'Jump to word',
      },
      {
        'L',
        function()
          require('hop').hint_lines()
        end,
        desc = 'Jump to line',
      },
    }
  end,
  config = function()
    require('hop').setup { keys = 'etovxqpdygfblzhckisuran' }
  end,
}
