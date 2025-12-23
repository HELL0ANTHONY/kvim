-- go install github.com/dkorunic/betteralign/cmd/betteralign@latest
-- Hace falta instalar los formateadores correspondientes para que funcione el formateo de Go.

local js_formatters = { 'prettierd', 'prettier', stop_after_first = true }
local slow_filetypes = { terraform = true, hcl = true, tf = true }

return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_format = 'fallback' }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = true,
    format_on_save = function(bufnr)
      local ft = vim.bo[bufnr].filetype
      local disable_lsp = { c = true, cpp = true }
      return {
        timeout_ms = slow_filetypes[ft] and 5000 or 3000,
        lsp_format = disable_lsp[ft] and 'never' or 'fallback',
      }
    end,
    formatters_by_ft = {
      css = js_formatters,
      go = { 'goimports-reviser', 'gofumpt', 'golines' },
      hcl = { 'terraform_fmt' },
      html = { 'prettierd' },
      javascript = js_formatters,
      javascriptreact = js_formatters,
      json = { 'prettierd' },
      json5 = { 'prettierd' },
      jsonc = { 'prettierd' },
      lua = { 'stylua' },
      markdown = { 'prettierd' },
      powershell = { 'prettierd' },
      terraform = { 'terraform_fmt' },
      ['terraform-vars'] = { 'terraform_fmt' },
      tf = { 'terraform_fmt' },
      typescript = js_formatters,
      typescriptreact = js_formatters,
      yaml = { 'yamlfmt' },
    },
  },
}
