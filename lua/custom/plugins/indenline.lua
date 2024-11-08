return {
  'lukas-reineke/indent-blankline.nvim',
  main = 'ibl',
  ft = {
    'yaml',
    'python',
  },
  config = function()
    local highlight = {
      'CursorColumn',
      'Whitespace',
    }

    require('ibl').setup {
      scope = {
        enabled = false,
        show_start = false,
      },
      whitespace = {
        highlight = highlight,
        remove_blankline_trail = false,
      },
      indent = { highlight = highlight, char = '' },
      exclude = {
        filetypes = {
          'help',
          'startify',
          'dashboard',
          'lazy',
          'neogitstatus',
          'NvimTree',
          'Trouble',
          'text',
        },
      },
    }
  end,
}
