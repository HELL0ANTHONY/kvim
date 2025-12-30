return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      {
        "williamboman/mason.nvim",
        opts = { PATH = "prepend" },
        build = ":MasonUpdate",
      },
      { "williamboman/mason-lspconfig.nvim" },
      {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        opts = {
          ensure_installed = {
            "emmet-language-server",
            "eslint_d",
            "gofumpt",
            "goimports-reviser",
            "golangci-lint",
            "golines",
            "gopls",
            "html-lsp",
            "json-lsp",
            "lua-language-server",
            "prettierd",
            "stylua",
            "tailwindcss-language-server",
            "terraform-ls",
            "tflint",
            "typescript-language-server",
            "yaml-language-server",
            "yamlfmt",
            "yamllint",
          },
          run_on_start = true,
        },
      },
      { "j-hui/fidget.nvim", opts = {} },
    },
    config = function()
      local lspconfig = require("lspconfig")
      local ok_blink, blink = pcall(require, "blink.cmp")
      local capabilities = ok_blink and blink.get_lsp_capabilities()
        or vim.lsp.protocol.make_client_capabilities()

      -- Keymaps on attach
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(e)
          local map = function(keys, fn, desc)
            vim.keymap.set(
              "n",
              keys,
              fn,
              { buffer = e.buf, desc = "LSP: " .. desc }
            )
          end

          -- Se prioriza el uso de comandos por defecto: gra, grn, grr, gri, etc.
          map("gd", vim.lsp.buf.definition, "Goto definition")
          map("gD", vim.lsp.buf.declaration, "Goto declaration")
          -- map('gr', vim.lsp.buf.references, 'References')
          -- map('gi', vim.lsp.buf.implementation, 'Implementation')
          -- map('<leader>rn', vim.lsp.buf.rename, 'Rename')
          -- map('<leader>ca', vim.lsp.buf.code_action, 'Code action')
          map("<leader>dd", vim.diagnostic.open_float, "Diagnostic float")
          map("K", function()
            vim.lsp.buf.hover({ border = "single" })
          end, "Hover")
        end,
      })

      -- Servers config
      local servers = {
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              staticcheck = true,
              completeUnimported = true,
              hints = { assignVariableTypes = true, parameterNames = true },
              analyses = {
                fieldalignment = true,
              },
            },
          },
        },
        ts_ls = {},
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
              completion = { callSnippet = "Replace" },
            },
          },
        },
        html = {},
        cssls = {},
        jsonls = {},
        yamlls = {
          settings = {
            yaml = {
              schemas = {
                kubernetes = "*.k8s.yaml",
                ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
              },
            },
          },
        },
        terraformls = {},
        emmet_ls = {
          filetypes = {
            "html",
            "css",
            "scss",
            "javascriptreact",
            "typescriptreact",
          },
        },
        tailwindcss = {
          filetypes = {
            "html",
            "javascript",
            "javascriptreact",
            "typescriptreact",
            "typescript",
          },
        },
      }

      require("mason-lspconfig").setup({
        ensure_installed = vim.tbl_keys(servers),
        handlers = {
          function(server)
            local opts = servers[server] or {}
            opts.capabilities = capabilities
            lspconfig[server].setup(opts)
          end,
        },
      })

      -- Diagnostics: solo float, sin virtual_text
      vim.diagnostic.config({
        virtual_text = false,
        float = {
          focusable = true,
          border = "single",
          header = "",
          prefix = "",
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.INFO] = " ",
            [vim.diagnostic.severity.HINT] = "󰠠 ",
          },
          linehl = {
            [vim.diagnostic.severity.ERROR] = "Error",
            [vim.diagnostic.severity.WARN] = "Warn",
            [vim.diagnostic.severity.INFO] = "Info",
            [vim.diagnostic.severity.HINT] = "Hint",
          },
        },
      })
    end,
  },
}
