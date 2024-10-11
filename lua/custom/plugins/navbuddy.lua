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

vim.keymap.set('n', '<leader>os', function()
  require('nvim-navbuddy').open()
end, { desc = 'LSP: [o]pen [s]ymbols navigation' })

return plugin
