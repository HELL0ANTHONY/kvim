local js_ts_formatters = { 'prettierd', 'prettier', stop_after_first = true }

local function formatter_exists(formatter)
  return vim.fn.executable(formatter) == 1
end

local function get_timeout(filetype)
  if filetype == 'terraform' or filetype == 'hcl' then
    return 5000
  end
  return 1000
end

local function format_on_save(bufnr)
  local disable_filetypes = { c = true, cpp = true }
  local filetype = vim.bo[bufnr].filetype
  local lsp_format_opt = disable_filetypes[filetype] and 'never' or 'fallback'

  return {
    timeout_ms = get_timeout(filetype),
    lsp_format = lsp_format_opt,
  }
end

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
    error_handler = function(err)
      if err then
        vim.notify('Formateo fallido: ' .. err, vim.log.levels.ERROR)
      end
    end,
    format_on_save = format_on_save,
    formatters_by_ft = {
      lua = { 'stylua' },
      json = formatter_exists 'prettierd' and { 'prettierd' } or { 'json-tool' },
      json5 = { 'prettierd' },
      jsonc = { 'prettierd' },
      html = { 'prettierd' },
      powershell = { 'prettierd' },
      markdown = { 'prettierd' },
      javascript = js_ts_formatters,
      javascriptreact = js_ts_formatters,
      typescript = js_ts_formatters,
      typescriptreact = js_ts_formatters,
      ['terraform-vars'] = { 'terraform_fmt' },
      hcl = { 'terraform_fmt' },
      terraform = { 'terraform_fmt' },
      tf = { 'terraform_fmt' },
      go = { 'goimports-reviser', 'gofumpt', 'golines' },
    },
  },
}
