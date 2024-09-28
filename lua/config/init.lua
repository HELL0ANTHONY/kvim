require 'config.options'
require 'config.keymaps'
require 'config.autocommads'

vim.fn.sign_define('DiagnosticSignError', { text = '', hl = 'DiagnosticSignError', texthl = 'DiagnosticSignError', culhl = 'DiagnosticSignErrorLine' })
vim.fn.sign_define('DiagnosticSignWarn', { text = '', hl = 'DiagnosticSignWarn', texthl = 'DiagnosticSignWarn', culhl = 'DiagnosticSignWarnLine' })
vim.fn.sign_define('DiagnosticSignInfo', { text = '', hl = 'DiagnosticSignInfo', texthl = 'DiagnosticSignInfo', culhl = 'DiagnosticSignInfoLine' })
vim.fn.sign_define('DiagnosticSignHint', { text = '', hl = 'DiagnosticSignHint', texthl = 'DiagnosticSignHint', culhl = 'DiagnosticSignHintLine' })
