-- https://github.com/exosyphon/nvim/blob/main/lua/plugins/lsp.lua
-- https://lsp-zero.netlify.app/docs/getting-started.html

return {
  'VonHeikemen/lsp-zero.nvim',
  branch = 'v4.x',
  dependencies = {
    { 'neovim/nvim-lspconfig' },
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
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

    local lsp_highlight_group = vim.api.nvim_create_augroup('LspHighlight', { clear = true })

    lsp.on_attach(function(_, bufnr)
      if vim.b[bufnr].lsp_keymaps_set then
        return
      end
      vim.b[bufnr].lsp_keymaps_set = true

      local function map(keys, rhs, desc, mode)
        vim.keymap.set(mode or 'n', keys, rhs, { noremap = true, silent = true, buffer = bufnr, desc = desc })
      end

      map('gd', vim.lsp.buf.definition, 'LSP: [g]oto [d]efinition')
      map('gI', require('telescope.builtin').lsp_implementations, 'LSP: [g]oto [I]mplementation')
      map('gD', vim.lsp.buf.declaration, 'LSP: [g]oto [D]eclaration')
      map('gr', require('telescope.builtin').lsp_references, 'LSP: [g]oto [r]eferences')
      map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'LSP: Type [D]efinition')
      map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'LSP: [w]orkspace [s]ymbols')
      map('<leader>ca', vim.lsp.buf.code_action, 'LSP: [c]ode [a]ction')
      map('<leader>rn', vim.lsp.buf.rename, 'LSP: [r]e[n]ame')
      map('<leader>oe', vim.diagnostic.open_float, 'LSP: [o]pen [e]rror diagnostic')
      map('<leader>od', vim.diagnostic.setloclist, 'LSP: [o]pen [d]iagnostics')
      map('<leader>ow', vim.diagnostic.setqflist, 'LSP: [o]pen workspace [w]ide diagnostics')
      map('K', vim.lsp.buf.hover, 'LSP: Hover')
      vim.keymap.set('i', '<C-h>', vim.lsp.buf.signature_help, { noremap = true, silent = true, buffer = bufnr, desc = 'LSP: Signature Help' })
    end)

    local servers = {
      gopls = {
        cmd = { 'gopls' },
        filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
        settings = {
          gopls = {
            experimentalPostfixCompletions = true,
            gofumpt = true,
            completeUnimported = true,
            staticcheck = true,
            -- usePlaceholders = true,
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
              fieldalignment = true,
              nilness = true,
              unusedparams = true,
              unusedwrite = true,
              useany = true,
            },
          },
        },
      },
      rust_analyzer = {},
      terraformls = {},
      ts_ls = {},
      lua_ls = {
        settings = {
          Lua = {
            completion = {
              callSnippet = 'Replace',
            },
          },
        },
      },
    }

    local function setup_server(server_name, _)
      local server_opts = servers[server_name] or {}
      server_opts.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server_opts.capabilities or {})
      require('lspconfig')[server_name].setup(server_opts)
    end

    require('mason').setup {}

    local ensure_installed = vim.list_extend(vim.tbl_keys(servers), {
      'eslint_d',
      'golangci_lint_ls',
      'prettierd',
      'stylua',
      'tflint',
    })

    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    require('mason-lspconfig').setup {
      handlers = {
        lsp.default_setup,
        lua_ls = function()
          local lua_opts = lsp.nvim_lua_ls()
          require('lspconfig').lua_ls.setup(lua_opts)
        end,
        setup_server,
      },
    }

    vim.api.nvim_create_autocmd('LspAttach', {
      group = lsp_highlight_group,
      callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.supports_method 'textDocument/documentHighlight' then
          local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
          vim.api.nvim_clear_autocmds { group = highlight_augroup, buffer = event.buf }
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })
        end
      end,
    })
  end,
}
