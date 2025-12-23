vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'go',
  callback = function()
    vim.opt_local.colorcolumn = '100'
  end,
})

-- Cargar ui-select cuando se llame vim.ui.select
vim.api.nvim_create_autocmd('LspAttach', {
  once = true,
  callback = function()
    pcall(function()
      require('telescope').load_extension 'ui-select'
    end)
  end,
})
