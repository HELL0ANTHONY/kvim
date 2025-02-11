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
      {
        '<leader>wF',
        function()
          local directions = require('hop.hint').HintDirection

          require('hop').hint_char1 {
            direction = directions.BEFORE_CURSOR,
            current_line_only = true,
          }
        end,
        desc = '[w]orkspace: jump to [F] character before cursor (current line)',
      },
      {
        '<leader>wf',
        function()
          local directions = require('hop.hint').HintDirection

          require('hop').hint_char1 {
            direction = directions.AFTER_CURSOR,
            current_line_only = true,
          }
        end,
        desc = '[w]orkspace: jump to [f] character after cursor (current line)',
      },
    }
  end,
  opts = {
    keys = 'etovxqpdygfblzhckisuran',
  },
}
