-- https://github.com/exosyphon/nvim/blob/main/lua/plugins/lsp.lua
-- https://lsp-zero.netlify.app/docs/getting-started.html

return {
  'VonHeikemen/lsp-zero.nvim',
  branch = 'v4.x',
  dependencies = {
    {
      'neovim/nvim-lspconfig',
      version = '*',
    },
    {
      'williamboman/mason.nvim',
      build = function()
        vim.cmd 'MasonUpdate'
      end,
    },
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    { 'williamboman/mason-lspconfig.nvim' },
    { 'hrsh7th/nvim-cmp' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'j-hui/fidget.nvim', opts = {} },
  },

  config = function()
    local lsp = require 'lsp-zero'
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

    lsp.on_attach(function(_, bufnr)
      -- Configurar solo una vez por buffer
      if vim.b[bufnr].lsp_keymaps_set then
        return
      end
      vim.b[bufnr].lsp_keymaps_set = true

      local function map(keys, rhs, desc, mode)
        vim.keymap.set(mode or 'n', keys, rhs, { noremap = true, silent = true, buffer = bufnr, desc = desc })
      end

      -- grn in Normal mode maps to vim.lsp.buf.rename()
      -- grr in Normal mode maps to vim.lsp.buf.references()
      -- gri in Normal mode maps to vim.lsp.buf.implementation()
      -- gO in Normal mode maps to vim.lsp.buf.document_symbol()
      -- gra in Normal and Visual mode maps to vim.lsp.buf.code_action()
      -- CTRL-S in Insert and Select mode maps to vim.lsp.buf.signature_help()

      -- Keymaps personalizados
      map('gd', vim.lsp.buf.definition, 'LSP: [g]oto [d]efinition')
      map('gD', vim.lsp.buf.declaration, 'LSP: [g]oto [D]eclaration')

      map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'LSP: Type [D]efinition')

      -- map('<leader>ca', vim.lsp.buf.code_action, 'LSP: [c]ode [a]ction')
      -- map('gr', require('telescope.builtin').lsp_references, 'LSP: [g]oto [r]eferences')
      -- map('gI', require('telescope.builtin').lsp_implementations, 'LSP: [g]oto [I]mplementation')
      -- map('<leader>lr', vim.lsp.buf.rename, '[L]SP: [r]ename')
      -- vim.keymap.set('i', '<C-h>', vim.lsp.buf.signature_help, { noremap = true, silent = true, buffer = bufnr, desc = 'LSP: Signature Help' })
      map('<leader>oe', vim.diagnostic.open_float, 'LSP: [o]pen [e]rror diagnostic')
      map('<leader>od', vim.diagnostic.setloclist, 'LSP: [o]pen [d]iagnostics')
      map('<leader>ow', vim.diagnostic.setqflist, 'LSP: [o]pen workspace [w]ide diagnostics')

      map('K', function()
        vim.lsp.buf.hover { border = 'single' }
      end, 'LSP: Hover')
    end)

    -- Servidores configurados
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
        -- MasonInstall eslint-lsp@4.5.0
        settings = {
          useFlatConfig = true,
          workingDirectory = { mode = 'auto' },
          experimental = {
            useFlatConfig = nil,
          },
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
            directoryFilters = {
              '-.git',
              '-.vscode',
              '-.idea',
              '-.vscode-test',
              '-node_modules',
            },
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
      lua_ls = {
        settings = {
          Lua = {
            completion = {
              callSnippet = 'Replace',
            },
          },
        },
      },
      terraformls = {},
      rust_analyzer = {},

      powershell_es = {
        settings = {
          powershell = {
            codeFormatting = {
              Preset = 'Allman', -- O usa "Allman" si prefieres ese estilo
              IndentationSize = 2, -- Tamaño de indentación (4 espacios)
              PipelineIndentationStyle = 'IncreaseIndentationForFirstPipeline', -- Ajusta el estilo de pipeline
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
    }

    -- Configuración de Mason
    require('mason').setup {}

    -- Asegurar herramientas instaladas
    require('mason-tool-installer').setup {
      ensure_installed = {
        'eslint',
        'golangci_lint_ls',
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

    -- Configuración de mason-lspconfig
    require('mason-lspconfig').setup {
      ensure_installed = vim.tbl_keys(servers),
      automatic_installation = true,
    }

    -- require('mason-lspconfig').setup_handlers {
    require('mason-lspconfig').setup {
      function(server_name)
        local opts = servers[server_name] or {}
        opts.capabilities = capabilities
        require('lspconfig')[server_name].setup(opts)
      end,
    }

    -- Highlight para referencias de LSP
    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        local buff = event.buf

        if client and client:supports_method('textDocument/documentHighlight', buff) then
          local group = vim.api.nvim_create_augroup('LspDocumentHighlight', { clear = false })

          vim.api.nvim_clear_autocmds { group = group, buffer = buff }
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            group = group,
            buffer = buff,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            group = group,
            buffer = buff,
            callback = vim.lsp.buf.clear_references,
          })
        end
      end,
    })

    vim.diagnostic.config {
      virtual_text = true,
      float = {
        focusable = true,
        style = 'minimal',
        border = 'single',
        header = '',
        prefix = '',
      },

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
