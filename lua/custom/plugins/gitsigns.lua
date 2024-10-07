return {
  'lewis6991/gitsigns.nvim',
  event = 'BufEnter',
  opts = {
    signs_staged_enable = true,
    signs = {
      untracked = {
        text = '┋',
      },

      add = {
        text = '┃',
      },

      change = {
        text = '┃',
      },

      delete = {
        text = '',
      },

      topdelete = {
        text = '',
      },

      changedelete = {
        text = '┃',
      },
    },
  },

  signs_staged = {
    untracked = {
      text = '┋',
    },

    add = {
      text = '┃',
    },

    change = {
      text = '┃',
    },

    delete = {
      text = '',
    },

    topdelete = {
      text = '',
    },

    changedelete = {
      text = '┃',
    },
  },
}
