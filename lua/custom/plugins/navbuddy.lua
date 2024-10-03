local plugin = {
  'SmiteshP/nvim-navbuddy',
  dependencies = {
    'SmiteshP/nvim-navic',
    'MunifTanjim/nui.nvim',
    'neovim/nvim-lspconfig',
    'nvim-telescope/telescope.nvim',
  },
}

function plugin.config()
  local navbuddy = require 'nvim-navbuddy'

  navbuddy.setup {
    window = {
      border = 'rounded',
    },
    --- icons = require("george.icons").kind,
    lsp = { auto_attach = true },
  }
end

vim.keymap.set('n', '<leader>o', function()
  require('nvim-navbuddy').open()
end, { desc = 'Symbols navigation' })

return plugin
