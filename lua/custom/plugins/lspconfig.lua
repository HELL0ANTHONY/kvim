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
        pcall(vim.cmd, 'MasonUpdate')
      end,
    },
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    { 'williamboman/mason-lspconfig.nvim' },
    { 'hrsh7th/nvim-cmp' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'rafamadriz/friendly-snippets' },
  },

  config = function()
    local lsp = require 'lsp-zero'

    lsp.on_attach(function(_, bufnr)
      local map = function(keys, rhs, opts, mode)
        opts = vim.tbl_deep_extend('force', { noremap = true, silent = true }, opts or {})
        mode = mode or 'n'
        vim.keymap.set(mode, keys, rhs, opts)
      end

      local opts = { buffer = bufnr, remap = false }

      -- map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
      -- map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

      map('<leader>D', function()
        require('telescope.builtin').lsp_type_definitions()
      end, vim.tbl_deep_extend('force', opts, { desc = 'LSP: Type [D]efinition' }))

      map('gI', function()
        require('telescope.builtin').lsp_implementations()
      end, vim.tbl_deep_extend('force', opts, { desc = 'LSP: [g]oto [I]mplementation' }))

      map('gd', function()
        vim.lsp.buf.definition()
      end, vim.tbl_deep_extend('force', opts, { desc = 'LSP: [g]oto [d]efinition' }))

      map('gD', function()
        vim.lsp.buf.declaration()
      end, vim.tbl_deep_extend('force', opts, { desc = 'LSP: [g]oto [d]eclaration' }))

      map('gr', function()
        -- vim.lsp.buf.references()
        require('telescope.builtin').lsp_references()
      end, vim.tbl_deep_extend('force', opts, { desc = 'LSP: [g]oto [r]eferences' }))

      map('<leader>ws', function()
        require('telescope.builtin').lsp_dynamic_workspace_symbols()
      end, vim.tbl_deep_extend('force', opts, { desc = 'LSP: [w]okspace [s]ymbols' }))

      map('K', function()
        vim.lsp.buf.hover()
      end, vim.tbl_deep_extend('force', opts, { desc = 'LSP: hover' }))

      map('<leader>ca', function()
        vim.lsp.buf.code_action()
      end, vim.tbl_deep_extend('force', opts, { desc = 'LSP: [c]ode [a]ction' }))

      map('<leader>rn', function()
        vim.lsp.buf.rename()
      end, vim.tbl_deep_extend('force', opts, { desc = 'LSP: [r]e[n]ame' }))

      map('<leader>oe', function()
        vim.diagnostic.open_float()
      end, vim.tbl_deep_extend('force', opts, { desc = 'LSP: [o]pen [e]rror diagnostic' }))

      map('<leader>od', function()
        vim.diagnostic.setloclist()
      end, vim.tbl_deep_extend('force', opts, { desc = 'LSP: [o]pen [d]iagnostics' }))

      map('<leader>ow', function()
        vim.diagnostic.setqflist()
      end, vim.tbl_deep_extend('force', opts, { desc = 'LSP: [o]pen workspace [w]ide diagnostics' }))

      vim.keymap.set('i', '<C-h>', function()
        vim.lsp.buf.signature_help()
      end, vim.tbl_deep_extend('force', opts, { desc = 'LSP: Signature Help' }))

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
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

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
          --   map('<leader>th', function()
          --     vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
          --   end, '[t]oggle inlay [h]ints')
          -- end
        end,
      })
    end)

    local servers = {
      gopls = {},
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

    require('mason').setup {}

    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      'stylua',
      'eslint_d',
      'tflint',
    })

    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
    require('mason-lspconfig').setup {
      handlers = {
        lsp.default_setup,
        lua_ls = function()
          local lua_opts = lsp.nvim_lua_ls()
          require('lspconfig').lua_ls.setup(lua_opts)
        end,
        function(server_name)
          local server = servers[server_name] or {}
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
          require('lspconfig')[server_name].setup(server)
        end,
      },
    }
  end,
}
