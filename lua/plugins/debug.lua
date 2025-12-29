-- Lenguajes soportados:
-- Go: nvim-dap-go (usa Delve internamente)
-- JS/TS/JSX/TSX: nvim-dap-vscode-js con Chrome y Node
-- Python: nvim-dap-python (requiere pip install debugpy)
return {
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    keys = {
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "[D]ebug [B]reakpoint",
      },
      {
        "<leader>dB",
        function()
          require("dap").set_breakpoint(vim.fn.input("Condition: "))
        end,
        desc = "[D]ebug conditional [B]reakpoint",
      },
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
        desc = "[D]ebug [C]ontinue",
      },
      {
        "<leader>do",
        function()
          require("dap").step_over()
        end,
        desc = "[D]ebug step [O]ver",
      },
      {
        "<leader>di",
        function()
          require("dap").step_into()
        end,
        desc = "[D]ebug step [I]nto",
      },
      {
        "<leader>dO",
        function()
          require("dap").step_out()
        end,
        desc = "[D]ebug step [O]ut",
      },
      {
        "<leader>dr",
        function()
          require("dap").repl.toggle()
        end,
        desc = "[D]ebug [R]EPL",
      },
      {
        "<leader>dl",
        function()
          require("dap").run_last()
        end,
        desc = "[D]ebug [L]ast",
      },
      {
        "<leader>dt",
        function()
          require("dap").terminate()
        end,
        desc = "[D]ebug [T]erminate",
      },
    },
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
        keys = {
          {
            "<leader>du",
            function()
              require("dapui").toggle()
            end,
            desc = "[D]ebug [U]I toggle",
          },
          {
            "<leader>de",
            function()
              require("dapui").eval()
            end,
            desc = "[D]ebug [E]val",
            mode = { "n", "v" },
          },
        },
        opts = {
          layouts = {
            {
              elements = {
                { id = "scopes", size = 0.33 },
                { id = "breakpoints", size = 0.17 },
                { id = "stacks", size = 0.25 },
                { id = "watches", size = 0.25 },
              },
              size = 40,
              position = "left",
            },
            {
              elements = {
                { id = "repl", size = 0.5 },
                { id = "console", size = 0.5 },
              },
              size = 10,
              position = "bottom",
            },
          },
          floating = { border = "single" },
        },
        config = function(_, opts)
          local dap, dapui = require("dap"), require("dapui")
          dapui.setup(opts)
          -- Auto open/close UI
          dap.listeners.after.event_initialized["dapui"] = function()
            dapui.open()
          end
          dap.listeners.before.event_terminated["dapui"] = function()
            dapui.close()
          end
          dap.listeners.before.event_exited["dapui"] = function()
            dapui.close()
          end
        end,
      },
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = { commented = true, virt_text_pos = "eol" },
      },
      -- Go debugger
      {
        "leoluz/nvim-dap-go",
        ft = "go",
        opts = {
          dap_configurations = {
            {
              type = "go",
              name = "Debug Package",
              request = "launch",
              program = "${fileDirname}",
            },
          },
        },
      },
      -- JS/TS debugger (lazy loaded)
      {
        "mxsdev/nvim-dap-vscode-js",
        ft = {
          "javascript",
          "typescript",
          "javascriptreact",
          "typescriptreact",
        },
        dependencies = {
          {
            "microsoft/vscode-js-debug",
            build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
            cond = function()
              return vim.fn.isdirectory(
                vim.fn.stdpath("data") .. "/lazy/vscode-js-debug"
              ) == 0
            end,
          },
        },
        opts = {
          debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
          adapters = { "pwa-node", "pwa-chrome" },
        },
      },
      -- Python debugger
      {
        "mfussenegger/nvim-dap-python",
        ft = "python",
        config = function()
          -- Uses debugpy, install with: pip install debugpy
          require("dap-python").setup("python")
        end,
      },
    },
    config = function()
      local dap = require("dap")

      -- Signs
      vim.fn.sign_define(
        "DapBreakpoint",
        { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" }
      )
      vim.fn.sign_define(
        "DapBreakpointCondition",
        { text = "◐", texthl = "DapBreakpointCondition" }
      )
      vim.fn.sign_define(
        "DapStopped",
        { text = "▶", texthl = "DapStopped", linehl = "DapStoppedLine" }
      )

      -- JS/TS configurations
      for _, lang in ipairs({
        "javascript",
        "typescript",
        "javascriptreact",
        "typescriptreact",
      }) do
        dap.configurations[lang] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-chrome",
            request = "launch",
            name = "Launch Chrome",
            url = "http://localhost:3000",
            webRoot = "${workspaceFolder}",
          },
        }
      end
    end,
  },
}
