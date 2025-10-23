return {
  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'

      if lint.linters.golangcilint then
        lint.linters.golangcilint.cmd = '/usr/local/bin/golangci-lint'
      else
        vim.notify('golangcilint no está registrado en nvim-lint', vim.log.levels.WARN)
      end

      -- markdown = { 'markdownlint' },
      lint.linters_by_ft = {
        go = { 'golangcilint' },
        javascript = { 'eslint_d' },
        javascriptreact = { 'eslint_d' },
        terraform = { 'tflint' },
        typescript = { 'eslint_d' },
        typescriptreact = { 'eslint_d' },
        yaml = { 'yamllint' },
      }

      -- Create autocommand which carries out the actual linting
      -- on the specified events.
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}
