return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },

  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      go = { "golangcilint" },
      javascript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescript = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      terraform = { "tflint" },
      yaml = { "yamllint" },
    }

    local function get_local_eslint()
      local buf = vim.api.nvim_get_current_buf()
      local bufname = vim.api.nvim_buf_get_name(buf)
      if bufname == "" then
        return nil
      end

      local dir = vim.fn.fnamemodify(bufname, ":p:h")
      return vim.fs.find(
        { "node_modules/.bin/eslint_d", "node_modules/.bin/eslint" },
        { upward = true, path = dir }
      )[1]
    end

    local function configure_eslint()
      local local_bin = get_local_eslint()
      if local_bin and lint.linters.eslint_d then
        lint.linters.eslint_d.cmd = local_bin
      end
    end

    local js_fts = {
      javascript = true,
      javascriptreact = true,
      typescript = true,
      typescriptreact = true,
    }

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
      callback = function()
        if js_fts[vim.bo.filetype] then
          configure_eslint()
        end
        local ok, err = pcall(lint.try_lint)
        if not ok and err then
          vim.schedule(function()
            -- Silenciar errores de config de eslint (repos legacy sin deps)
            if type(err) == "string" and err:match("eslint") then return end
            vim.notify(err, vim.log.levels.WARN)
          end)
        end
      end,
    })
  end,
}
