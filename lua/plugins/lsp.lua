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
            "intelephense",
            "json-lsp",
            "lua-language-server",
            "php-cs-fixer",
            "phpcs",
            "postgres-language-server",
            "prettierd",
            "pyright",
            "ruff",
            "sqlfluff",
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

      local lspconfig_configs = require("lspconfig.configs")
      if not lspconfig_configs.postgres_lsp then
        lspconfig_configs.postgres_lsp = {
          default_config = {
            cmd = { "postgres-language-server", "lsp-proxy" },
            filetypes = { "sql" },
            root_dir = function(fname)
              return vim.fs.root(fname, { "postgres-language-server.jsonc", ".git" })
                or vim.fs.dirname(fname)
            end,
            single_file_support = true,
          },
        }
      end

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
          -- map('gr', vim.lsp.buf.references, 'References')
          -- map('gi', vim.lsp.buf.implementation, 'Implementation')
          -- map('<leader>rn', vim.lsp.buf.rename, 'Rename')
          -- map('<leader>ca', vim.lsp.buf.code_action, 'Code action')
          map("<leader>dd", vim.diagnostic.open_float, "Diagnostic float")
          map("K", vim.lsp.buf.hover, "Hover")
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
        postgres_lsp = {
          cmd = { "postgres-language-server", "lsp-proxy" },
          filetypes = { "sql" },
          root_dir = function(fname)
            return vim.fs.root(fname, { "postgres-language-server.jsonc", ".git" })
              or vim.fs.dirname(fname)
          end,
          single_file_support = true,
        },
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
        pyright = {
          settings = {
            python = {
              analysis = {
                autoSearchPaths        = true,
                useLibraryCodeForTypes = true,
                diagnosticMode         = "openFilesOnly",
                typeCheckingMode       = "basic",
              },
            },
          },
        },
        intelephense = {
          settings = {
            intelephense = {
              environment = { phpVersion = "8.3" },
              files = { maxSize = 1000000 },
              -- Stubs comunes para PHP moderno + extensiones populares
              stubs = {
                "apache", "bcmath", "bz2", "calendar", "com_dotnet", "Core",
                "ctype", "curl", "date", "dba", "dom", "enchant", "exif",
                "FFI", "fileinfo", "filter", "fpm", "ftp", "gd", "gettext",
                "gmp", "hash", "iconv", "imap", "intl", "json", "ldap",
                "libxml", "mbstring", "meta", "mysqli", "mysqlnd", "oci8",
                "odbc", "openssl", "pcntl", "pcre", "PDO", "pdo_ibm",
                "pdo_mysql", "pdo_pgsql", "pdo_sqlite", "pgsql", "Phar",
                "posix", "pspell", "random", "readline", "Reflection",
                "session", "shmop", "SimpleXML", "snmp", "soap", "sockets",
                "sodium", "SPL", "sqlite3", "standard", "superglobals",
                "sysvmsg", "sysvsem", "sysvshm", "tidy", "tokenizer",
                "xml", "xmlreader", "xmlrpc", "xmlwriter", "xsl", "Zend OPcache",
                "zip", "zlib",
                -- extensiones comunes de frameworks/DB
                "mongodb", "redis",
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

      -- Silenciar errores de eslint config (repos legacy sin deps instaladas)
      local original_notify = vim.notify
      vim.notify = function(msg, level, opts)
        if type(msg) == "string" and msg:match("eslint") and msg:match("Failed to load config") then
          return
        end
        original_notify(msg, level, opts)
      end

      -- Diagnostics: solo float, sin virtual_text
      vim.diagnostic.config({
        virtual_text = false,
        float = {
          focusable = true,
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
