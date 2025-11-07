return {
  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'

      -- golangci-lint local override (si lo necesitas)
      if lint.linters.golangcilint then
        lint.linters.golangcilint.cmd = '/usr/local/bin/golangci-lint'
      else
        vim.notify('golangcilint no está registrado en nvim-lint', vim.log.levels.WARN)
      end

      -- Archivos -> linter
      lint.linters_by_ft = {
        go = { 'golangcilint' },
        javascript = { 'eslint_d' },
        javascriptreact = { 'eslint_d' },
        typescript = { 'eslint_d' },
        typescriptreact = { 'eslint_d' },
        terraform = { 'tflint' },
        yaml = { 'yamllint' },
        -- markdown = { 'markdownlint' },
      }

      -- Busca el binario local de eslint_d o eslint empezando en el dir del buffer
      local function set_local_eslint_cmd()
        local buf = vim.api.nvim_get_current_buf()
        local bufname = vim.api.nvim_buf_get_name(buf)
        if bufname == '' then
          return
        end

        local dir = vim.fn.fnamemodify(bufname, ':p:h')
        local found = vim.fs.find({ 'node_modules/.bin/eslint_d', 'node_modules/.bin/eslint' }, { upward = true, path = dir })[1]

        -- Prepend al PATH el node_modules/.bin del proyecto (por si otros linters lo necesitan)
        local nmbin = vim.fs.find('node_modules/.bin', { upward = true, path = dir })[1]
        if nmbin and not string.find(vim.env.PATH or '', nmbin, 1, true) then
          vim.env.PATH = nmbin .. ':' .. (vim.env.PATH or '')
        end

        -- Configura el cmd del linter de JS/TS
        if found then
          if found:match 'eslint_d$' then
            if lint.linters.eslint_d then
              lint.linters.eslint_d.cmd = found
            end
          else
            -- No hay eslint_d local: usa eslint normal como backend del linter eslint_d
            -- (nvim-lint también trae "eslint"; si prefieres, cambia linters_by_ft a "eslint")
            if lint.linters.eslint_d then
              lint.linters.eslint_d.cmd = found
            end
          end
        end
      end

      -- Autocomando: antes de lint, fija el cmd local y corre
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          set_local_eslint_cmd()
          lint.try_lint()
        end,
      })
    end,
  },
}
