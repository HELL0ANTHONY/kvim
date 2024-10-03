local func = {}

-- run :Preview
-- vnew | Preview
-- Install ts-node for typescript
local attach_to_buffer = function(output_bufnr, patterns_and_commands)
  vim.api.nvim_create_autocmd('BufWritePost', {
    group = vim.api.nvim_create_augroup('Preview', { clear = true }),
    callback = function()
      local filetype = vim.bo.filetype
      local pattern_command = patterns_and_commands[filetype]

      if pattern_command then
        local command = pattern_command.command

        local file = vim.fn.expand '%:p'
        if string.match(file, ' ') then
          file = string.format('"%s"', file)
        end

        for i, v in ipairs(command) do
          if v == '%' then
            command[i] = file
            break
          end
        end

        local append_data = function(_, data)
          if data then
            vim.api.nvim_buf_set_lines(output_bufnr, -1, -1, false, data)
          end
        end

        vim.api.nvim_buf_set_lines(output_bufnr, 0, -1, false, { filetype .. ' output:' })
        vim.fn.jobstart(command, {
          stdout_buffered = true,
          on_stdout = append_data,
          on_stderr = append_data,
        })
      end
    end,
  })
end

vim.api.nvim_create_user_command('Preview', function()
  local patterns_and_commands = {
    javascript = {
      pattern = '*.js',
      command = { 'node', '%' },
    },
    typescript = {
      pattern = '*.ts',
      command = { 'ts-node', '%' },
    },
    javascriptreact = {
      pattern = '*.jsx',
      command = { 'node', '%' },
    },
    typescriptreact = {
      pattern = '*.tsx',
      command = { 'ts-node', '%' },
    },
    go = {
      pattern = '*.go',
      command = { 'go', 'run', '%' },
    },
    -- Add more languages here as needed
  }

  local bufnr = vim.api.nvim_get_current_buf()
  attach_to_buffer(tonumber(bufnr), patterns_and_commands)
end, {})

-- remove_comments Remove inline comments from one file
function func.remove_comments()
  local filetype = vim.bo.filetype
  local comment_chars = {
    go = '//',
    javascript = '//',
    javascriptreact = '//',
    lua = '--',
    python = '#',
    typescript = '//',
    typescriptreact = '//',
  }
  local comment_char = comment_chars[filetype]
  if comment_char then
    local command = string.format('%%s,\\v%s.*$,', comment_char)
    vim.api.nvim_command(command)
  else
    print 'No se ha encontrado un carácter de comentario para este tipo de archivo.'
  end
end

return func
