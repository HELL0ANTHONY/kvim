-- go install github.com/dkorunic/betteralign/cmd/betteralign@latest
-- Hace falta instalar los formateadores correspondientes para que funcione el formateo de Go.

vim.g.autoformat = true

local js_formatters = { "prettierd", "prettier", stop_after_first = true }
local slow_filetypes = { terraform = true, hcl = true, tf = true }
local sqlfluff_config_files =
  { ".sqlfluff", "pep8.ini", "pyproject.toml", "setup.cfg", "tox.ini" }

local function sqlfluff_root_dir(_, ctx)
  return vim.fs.root(ctx.dirname, sqlfluff_config_files) or ctx.dirname
end

local function sqlfluff_args(_, ctx)
  if vim.fs.root(ctx.dirname, sqlfluff_config_files) then
    return { "fix", "-" }
  end
  return { "fix", "--dialect", "ansi", "-" }
end

return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>f",
      function()
        require("conform").format({ async = true, lsp_format = "fallback" })
      end,
      mode = "n",
      desc = "[F]ormat buffer",
    },
    {
      "<leader>f",
      function()
        require("conform").format({
          async = true,
          lsp_format = "fallback",
          range = {
            start = vim.api.nvim_buf_get_mark(0, "<"),
            ["end"] = vim.api.nvim_buf_get_mark(0, ">"),
          },
        })
      end,
      mode = "v",
      desc = "[F]ormat selection",
    },
    {
      "<leader>ft",
      function()
        vim.g.autoformat = not vim.g.autoformat
        vim.notify("Format on save: " .. (vim.g.autoformat and "ON" or "OFF"))
      end,
      desc = "[F]ormat [T]oggle auto-save",
    },
  },
  opts = {
    notify_on_error = true,
    format_on_save = function(bufnr)
      if not vim.g.autoformat then
        return nil
      end
      local ft = vim.bo[bufnr].filetype
      local disable_lsp = { c = true, cpp = true }
      return {
        timeout_ms = slow_filetypes[ft] and 5000 or 3000,
        lsp_format = disable_lsp[ft] and "never" or "fallback",
      }
    end,
    formatters_by_ft = {
      css = js_formatters,
      go = { "goimports-reviser", "gofumpt", "golines" },
      hcl = { "terraform_fmt" },
      html = { "prettierd" },
      javascript = js_formatters,
      javascriptreact = js_formatters,
      json = { "prettierd" },
      json5 = { "prettierd" },
      jsonc = { "prettierd" },
      lua = { "stylua" },
      php = { "php_cs_fixer" },
      markdown = { "prettierd" },
      powershell = { "prettierd" },
      sql = { "sqlfluff" },
      terraform = { "terraform_fmt" },
      ["terraform-vars"] = { "terraform_fmt" },
      tf = { "terraform_fmt" },
      typescript = js_formatters,
      typescriptreact = js_formatters,
      yaml = { "yamlfmt" },
    },
    formatters = {
      sqlfluff = {
        cwd = sqlfluff_root_dir,
        args = sqlfluff_args,
        require_cwd = false,
      },
    },
  },
}
