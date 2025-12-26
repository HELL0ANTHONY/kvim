return {
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      -- Adapters (lazy, solo se cargan si el ft coincide)
      'fredrikaverpil/neotest-golang',
      'nvim-neotest/neotest-jest',
      'marilari88/neotest-vitest',
      'nvim-neotest/neotest-python',
    },
    keys = {
      {
        '<leader>tr',
        function()
          require('neotest').run.run()
        end,
        desc = '[T]est [R]un nearest',
      },
      {
        '<leader>tf',
        function()
          require('neotest').run.run(vim.fn.expand '%')
        end,
        desc = '[T]est [F]ile',
      },
      {
        '<leader>ts',
        function()
          require('neotest').summary.toggle()
        end,
        desc = '[T]est [S]ummary',
      },
      {
        '<leader>to',
        function()
          require('neotest').output.open { enter = true }
        end,
        desc = '[T]est [O]utput',
      },
      {
        '<leader>tp',
        function()
          require('neotest').output_panel.toggle()
        end,
        desc = '[T]est [P]anel',
      },
      {
        '<leader>td',
        function()
          require('neotest').run.run { strategy = 'dap' }
        end,
        desc = '[T]est [D]ebug nearest',
      },
      {
        '<leader>tD',
        function()
          require('neotest').run.run { vim.fn.expand '%', strategy = 'dap' }
        end,
        desc = '[T]est [D]ebug file',
      },
      {
        '<leader>tl',
        function()
          require('neotest').run.run_last()
        end,
        desc = '[T]est [L]ast',
      },
      {
        '<leader>tw',
        function()
          require('neotest').watch.toggle(vim.fn.expand '%')
        end,
        desc = '[T]est [W]atch file',
      },
    },
    config = function()
      require('neotest').setup {
        adapters = {
          require 'neotest-golang' {
            go_test_args = { '-v', '-race', '-coverprofile=coverage.out' },
          },
          require 'neotest-jest' {
            jestCommand = 'npm test --',
            cwd = function()
              return vim.fn.getcwd()
            end,
          },
          require 'neotest-vitest',
          require 'neotest-python' {
            dap = { justMyCode = false },
            runner = 'pytest',
          },
        },
        output = { open_on_run = false },
        summary = { mappings = { expand = '<CR>', jumpto = '<Tab>' } },
        status = { virtual_text = true, signs = true },
        quickfix = { enabled = true, open = false },
      }
    end,
  },
}
