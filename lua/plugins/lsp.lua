return {
  'VonHeikemen/lsp-zero.nvim',
  branch = 'v4.x',
  event = { 'BufReadPre', 'BufNewFile' },

  dependencies = {
    'neovim/nvim-lspconfig',
    {
      'williamboman/mason.nvim',
      cmd = { 'Mason', 'MasonInstall', 'MasonUpdate' },
      opts = { PATH = 'prepend' },
      build = ':MasonUpdate',
    },
    {
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      event = 'VeryLazy',
      dependencies = { 'williamboman/mason.nvim' },
      opts = {
        ensure_installed = {
          -- LSP servers
          'emmet-language-server',
          'gopls',
          'html-lsp',
          'json-lsp',
          'lua-language-server',
          'powershell-editor-services',
          'rust-analyzer',
          'tailwindcss-language-server',
          'terraform-ls',
          'typescript-language-server',
          'yaml-language-server',
          -- Linters (usados en nvim-lint)
          'eslint_d',
          'golangci-lint',
          'tflint',
          'yamllint',
          -- Formatters (usados en conform)
          'gofumpt',
          'goimports-reviser',
          'golines',
          'prettierd',
          'stylua',
          'yamlfmt',
        },
        run_on_start = true,
      },
    },
    {
      'williamboman/mason-lspconfig.nvim',
      dependencies = { 'williamboman/mason.nvim' },
    },
    { 'j-hui/fidget.nvim', opts = {} },
  },

  config = function()
    local lsp = require 'lsp-zero'
    local ok_blink, blink = pcall(require, 'blink.cmp')
    local capabilities = ok_blink and blink.get_lsp_capabilities() or vim.lsp.protocol.make_client_capabilities()

    -- Solo keymaps que NO son nativos en Neovim 0.11+
    lsp.on_attach(function(_, bufnr)
      local map = function(keys, fn, desc)
        vim.keymap.set('n', keys, fn, { buffer = bufnr, silent = true, desc = desc })
      end
      map('gd', vim.lsp.buf.definition, 'LSP: Goto definition')
      map('gD', vim.lsp.buf.declaration, 'LSP: Goto declaration')
      map('<leader>oe', vim.diagnostic.open_float, 'Diagnostic float')
      map('K', function()
        vim.lsp.buf.hover { border = 'single' }
      end, 'Hover')
    end)

    local servers = {
      emmet_ls = {
        filetypes = { 'html', 'css', 'scss', 'javascriptreact', 'typescriptreact' },
        init_options = {
          includeLanguages = { javascript = 'javascriptreact', typescript = 'typescriptreact' },
          html = { options = { ['bem.enabled'] = true } },
        },
      },
      yamlls = {
        settings = {
          yaml = {
            schemas = {
              kubernetes = '*.k8s.yaml',
              ['https://json.schemastore.org/github-workflow.json'] = '/.github/workflows/*',
            },
          },
        },
      },
      gopls = {
        settings = {
          gopls = {
            gofumpt = true,
            staticcheck = true,
            completeUnimported = true,
            hints = { assignVariableTypes = true, parameterNames = true },
          },
        },
      },
      lua_ls = {
        settings = {
          Lua = {
            diagnostics = { globals = { 'vim' } },
            completion = { callSnippet = 'Replace' },
          },
        },
      },
      tailwindcss = {
        filetypes = { 'html', 'javascript', 'javascriptreact', 'typescriptreact', 'typescript' },
        settings = {
          tailwindCSS = {
            validate = true,
            classAttributes = { 'class', 'className', 'ngClass' },
            lint = {
              cssConflict = 'warning',
              invalidApply = 'error',
              invalidScreen = 'error',
              invalidVariant = 'error',
              invalidConfigPath = 'error',
              invalidTailwindDirective = 'error',
              recommendedVariantOrder = 'warning',
            },
          },
        },
      },
      terraformls = {},
      rust_analyzer = {},
      jsonls = {},
      html = {},
      ts_ls = {},
    }

    local mlsp = require 'mason-lspconfig'
    local function handler(name)
      local opts = servers[name] or {}
      opts.capabilities = capabilities
      require('lspconfig')[name].setup(opts)
    end

    mlsp.setup {
      ensure_installed = vim.tbl_keys(servers),
      automatic_installation = true,
      handlers = { handler },
    }

    vim.diagnostic.config {
      virtual_text = true,
      float = { focusable = true, style = 'minimal', border = 'single', header = '', prefix = '' },
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = ' ',
          [vim.diagnostic.severity.WARN] = ' ',
          [vim.diagnostic.severity.INFO] = ' ',
          [vim.diagnostic.severity.HINT] = '󰠠 ',
        },
        linehl = {
          [vim.diagnostic.severity.ERROR] = 'Error',
          [vim.diagnostic.severity.WARN] = 'Warn',
          [vim.diagnostic.severity.INFO] = 'Info',
          [vim.diagnostic.severity.HINT] = 'Hint',
        },
      },
    }
  end,
}
