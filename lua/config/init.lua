require 'config.custom_functions'
require 'config.options'
require 'config.keymaps'
require 'config.autocommads'

vim.fn.sign_define('DiagnosticSignError', { text = '', hl = 'DiagnosticSignError', texthl = 'DiagnosticSignError', culhl = 'DiagnosticSignErrorLine' })
vim.fn.sign_define('DiagnosticSignWarn', { text = '', hl = 'DiagnosticSignWarn', texthl = 'DiagnosticSignWarn', culhl = 'DiagnosticSignWarnLine' })
vim.fn.sign_define('DiagnosticSignInfo', { text = '', hl = 'DiagnosticSignInfo', texthl = 'DiagnosticSignInfo', culhl = 'DiagnosticSignInfoLine' })
vim.fn.sign_define('DiagnosticSignHint', { text = '', hl = 'DiagnosticSignHint', texthl = 'DiagnosticSignHint', culhl = 'DiagnosticSignHintLine' })

vim.diagnostic.config {
  -- virtual_text = true,
  -- update_in_insert = false,
  -- underline = true,
  -- severity_sort = true,
  float = {
    focusable = true,
    style = 'minimal',
    border = 'single', --'rounded',
    header = '',
    prefix = '',
  },
}

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'single' })
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'single' })
