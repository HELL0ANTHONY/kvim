return {
  'phaazon/hop.nvim',
  branch = 'v2',
  keys = function()
    return {
      {
        '<leader>jw',
        function()
          require('hop').hint_words()
        end,
        desc = '[j]ump to [w]ord',
      },
      {
        '<leader>jl',
        function()
          require('hop').hint_lines()
        end,
        desc = '[j]ump to [l]ine',
      },
    }
  end,
  config = function()
    require('hop').setup { keys = 'etovxqpdygfblzhckisuran' }
  end,
}
