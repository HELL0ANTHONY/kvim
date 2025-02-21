-- https://github.com/fnune/recall.nvim
return {
  'fnune/recall.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local recall = require 'recall'
    local is_nvim_0_10 = vim.fn.has 'nvim-0.10' == 1

    recall.setup {
      sign = '',
      sign_highlight = 'Character', -- más opciones :highlight

      telescope = {
        autoload = true,
        mappings = {
          unmark_selected_entry = {
            normal = 'dd',
            insert = '<M-d>',
          },
        },
      },

      wshada = not is_nvim_0_10, -- se usa wshada si neovim es inferior a la versión 10
    }
  end,
}
