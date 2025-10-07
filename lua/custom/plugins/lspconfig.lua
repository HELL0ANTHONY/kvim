-- https://github.com/exosyphon/nvim/blob/main/lua/plugins/lsp.lua
-- https://lsp-zero.netlify.app/docs/getting-started.html

return {
  'VonHeikemen/lsp-zero.nvim',
  branch = 'v4.x',
  dependencies = {
    { 'neovim/nvim-lspconfig', version = '*' },
    {
      'williamboman/mason.nvim',
      build = function()
        vim.cmd 'MasonUpdate'
      end,
    },
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    { 'williamboman/mason-lspconfig.nvim' },
    { 'j-hui/fidget.nvim', opts = {} },
    -- Nota: NO usamos nvim-cmp ni cmp-nvim-lsp (blink reemplaza eso)
  },

  config = function()
    local lsp = require 'lsp-zero'

    -- Capabilities: usamos blink si está disponible; si no, fallback seguro.
    local ok_blink, blink = pcall(require, 'blink.cmp')
    local capabilities = ok_blink and blink.get_lsp_capabilities() or vim.lsp.protocol.make_client_capabilities()

    -- on_attach con tus keymaps
    lsp.on_attach(function(_, bufnr)
      if vim.b[bufnr].lsp_keymaps_set then
        return
      end
      vim.b[bufnr].lsp_keymaps_set = true

      local function map(keys, rhs, desc, mode)
        vim.keymap.set(mode or 'n', keys, rhs, { noremap = true, silent = true, buffer = bufnr, desc = desc })
      end

      map('gd', vim.lsp.buf.definition, 'LSP: [g]oto [d]efinition')
      map('gD', vim.lsp.buf.declaration, 'LSP: [g]oto [D]eclaration')
      map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'LSP: Type [D]efinition')
      map('<leader>oe', vim.diagnostic.open_float, 'LSP: [o]pen [e]rror diagnostic')
      map('<leader>od', vim.diagnostic.setloclist, 'LSP: [o]pen [d]iagnostics')
      map('<leader>ow', vim.diagnostic.setqflist, 'LSP: [o]pen workspace [w]ide diagnostics')
      map('K', function()
        vim.lsp.buf.hover { border = 'single' }
      end, 'LSP: Hover')
    end)

    -- Tu tabla de servers (sin cambios de intención)
    local servers = {
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
      eslint = {
        settings = {
          useFlatConfig = true,
          workingDirectory = { mode = 'auto' },
          experimental = { useFlatConfig = nil },
        },
      },
      gopls = {
        settings = {
          gopls = {
            experimentalPostfixCompletions = true,
            gofumpt = true,
            completeUnimported = true,
            staticcheck = true,
            linksInHover = true,
            directoryFilters = { '-.git', '-.vscode', '-.idea', '-.vscode-test', '-node_modules' },
            semanticTokens = true,
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
            codelenses = {
              gc_details = false,
              generate = true,
              regenerate_cgo = true,
              run_govulncheck = true,
              test = true,
              tidy = true,
              upgrade_dependency = true,
              vendor = true,
            },
            analyses = {
              nilness = true,
              unusedparams = true,
              unusedwrite = true,
              useany = true,
            },
          },
        },
      },
      lua_ls = { settings = { Lua = { completion = { callSnippet = 'Replace' } } } },
      terraformls = {},
      rust_analyzer = {},
      powershell_es = {
        settings = {
          powershell = {
            codeFormatting = {
              Preset = 'Allman',
              IndentationSize = 2,
              PipelineIndentationStyle = 'IncreaseIndentationForFirstPipeline',
              scriptAnalyzer = {
                settingsPath = 'C:/Users/georg/AppData/Local/nvim/PSScriptAnalyzerSettings.psd1',
              },
            },
          },
        },
      },
      jsonls = {},
      html = {},
      ts_ls = {},
      -- golangci_lint_ls = { ... },
    }

    -- mason base
    require('mason').setup {}

    -- herramientas que querés tener instaladas
    require('mason-tool-installer').setup {
      ensure_installed = {
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
    }

    -- mason-lspconfig con compatibilidad de APIs (setup.handlers vs setup_handlers)
    local mlsp = require 'mason-lspconfig'

    local function default_handler(server_name)
      local opts = servers[server_name] or {}
      opts.capabilities = capabilities
      require('lspconfig')[server_name].setup(opts)
    end

    if type(mlsp.setup_handlers) == 'function' then
      -- API antigua
      mlsp.setup {
        ensure_installed = vim.tbl_keys(servers),
        automatic_installation = true,
      }
      mlsp.setup_handlers { default_handler }
    else
      -- API nueva (handlers dentro de setup)
      mlsp.setup {
        ensure_installed = vim.tbl_keys(servers),
        automatic_installation = true,
        handlers = { default_handler },
      }
    end

    -- Highlights de referencias LSP
    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        local buff = event.buf
        if client and client:supports_method('textDocument/documentHighlight', buff) then
          local group = vim.api.nvim_create_augroup('LspDocumentHighlight', { clear = false })
          vim.api.nvim_clear_autocmds { group = group, buffer = buff }
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, { group = group, buffer = buff, callback = vim.lsp.buf.document_highlight })
          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, { group = group, buffer = buff, callback = vim.lsp.buf.clear_references })
        end
      end,
    })

    -- Diagnostics UI
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
