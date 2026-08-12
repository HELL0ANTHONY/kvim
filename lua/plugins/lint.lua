return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },

  config = function()
    local lint = require("lint")
    local sqlfluff_config_files =
      { ".sqlfluff", "pep8.ini", "pyproject.toml", "setup.cfg", "tox.ini" }
    local phpcs_config_files =
      { "phpcs.xml", ".phpcs.xml", "phpcs.xml.dist", ".phpcs.xml.dist" }

    local function has_sqlfluff_config()
      local bufname = vim.api.nvim_buf_get_name(0)
      local path = bufname ~= "" and vim.fn.fnamemodify(bufname, ":p:h") or vim.uv.cwd()
      return vim.fs.find(sqlfluff_config_files, { upward = true, path = path })[1] ~= nil
    end

    local function has_phpcs_config()
      local bufname = vim.api.nvim_buf_get_name(0)
      local path = bufname ~= "" and vim.fn.fnamemodify(bufname, ":p:h") or vim.uv.cwd()
      return vim.fs.find(phpcs_config_files, { upward = true, path = path })[1] ~= nil
    end

    lint.linters_by_ft = {
      go = { "golangcilint" },
      javascript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescript = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      php    = { "phpcs" },
      python = { "ruff" },
      sql    = { "sqlfluff" },
      terraform = { "tflint" },
      yaml = { "yamllint" },
    }

    -- phpcs: si no hay config en el proyecto, usa PSR2 como estándar por defecto
    local phpcs_linter = require("lint.linters.phpcs")
    lint.linters.phpcs = function()
      local linter = vim.deepcopy(phpcs_linter)
      if not has_phpcs_config() then
        -- Insertar --standard=PSR2 después del primer arg
        table.insert(linter.args, 1, "--standard=PSR2")
      end
      return linter
    end

    local sqlfluff_linter = require("lint.linters.sqlfluff")
    lint.linters.sqlfluff = function()
      local linter = vim.deepcopy(sqlfluff_linter)
      linter.args = has_sqlfluff_config()
          and { "lint", "--format=json", "-" }
        or { "lint", "--dialect", "ansi", "--format=json", "-" }
      return linter
    end

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

    -- Mapa de binario real por nombre de linter (para chequear si está instalado)
    local linter_binaries = {
      eslint_d  = "eslint_d",
      phpcs     = "phpcs",
      ruff      = "ruff",
      sqlfluff  = "sqlfluff",
      tflint    = "tflint",
      yamllint  = "yamllint",
    }

    -- Retorna solo los linters del filetype actual que tienen su binario disponible
    local function available_linters()
      local ft = vim.bo.filetype
      local names = lint.linters_by_ft[ft]
      if not names then return {} end
      return vim.tbl_filter(function(name)
        local bin = linter_binaries[name]
        if bin then return vim.fn.executable(bin) == 1 end
        return true -- linters sin mapeo directo pasan siempre (ej: golangcilint)
      end, names)
    end

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
      callback = function()
        if js_fts[vim.bo.filetype] then
          configure_eslint()
        end
        local linters = available_linters()
        if #linters == 0 then return end
        local ok, err = pcall(lint.try_lint, linters)
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
