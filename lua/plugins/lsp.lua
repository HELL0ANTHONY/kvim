return {
  'VonHeikemen/lsp-zero.nvim',
  branch = 'v4.x',

  event = { 'BufReadPre', 'BufNewFile' },
  -- lazy = true,  -- ⛔ quítalo o déjalo, pero con el event ya carga

  dependencies = {
    {
      'neovim/nvim-lspconfig',
      -- version = '*', -- opcional; puedes quitar el pin
    },
    {
      'williamboman/mason.nvim',
      cmd = { 'Mason', 'MasonInstall', 'MasonUpdate' },
      opts = { PATH = 'prepend' },
      build = function()
        vim.cmd 'MasonUpdate'
      end,
    },
    {
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      event = 'VeryLazy',
      -- ⛔ estabas usando `run_on_start` arriba del spec; debe ir en `opts`
      opts = {
        ensure_installed = {
          'emmet_ls',
          'eslint',
          'golangci-lint',
          'gopls',
          'html',
          'lua_ls',
          'powershell_es',
          'prettierd',
          'rust_analyzer',
          'stylua',
          'taplo',
          'terraformls',
          'ts_ls',
          'yamlfmt',
          'yamllint',
        },
        run_on_start = true,
      },
      dependencies = { 'williamboman/mason.nvim' },
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

    lsp.on_attach(function(_, bufnr)
      if vim.b[bufnr].lsp_keymaps_set then
        return
      end
      vim.b[bufnr].lsp_keymaps_set = true
      local map = function(keys, rhs, desc, mode)
        vim.keymap.set(mode or 'n', keys, rhs, { buffer = bufnr, silent = true, desc = desc })
      end
      map('gd', vim.lsp.buf.definition, 'LSP: Goto def')
      map('gD', vim.lsp.buf.declaration, 'LSP: Goto decl')
      map('<leader>oe', vim.diagnostic.open_float, 'Diag float')
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
      eslint = { settings = { useFlatConfig = true, workingDirectory = { mode = 'auto' } } },
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
      lua_ls = { settings = { Lua = { completion = { callSnippet = 'Replace' } } } },
      terraformls = {},
      rust_analyzer = {},
      jsonls = {},
      html = {},
      ts_ls = {},
    }

    require('mason').setup { PATH = 'prepend' }

    local mlsp = require 'mason-lspconfig'

    local function handler(name)
      local opts = servers[name] or {}
      opts.capabilities = capabilities
      require('lspconfig')[name].setup(opts)
    end

    if type(mlsp.setup_handlers) == 'function' then
      mlsp.setup { ensure_installed = vim.tbl_keys(servers), automatic_installation = true }
      mlsp.setup_handlers { handler }
    else
      mlsp.setup {
        ensure_installed = vim.tbl_keys(servers),
        automatic_installation = true,
        handlers = { handler },
      }
    end

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
