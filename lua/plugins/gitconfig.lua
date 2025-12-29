return {
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview Open" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File History" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Branch History" },
    },
    config = function()
      local actions = require("diffview.actions")

      -- Colores sutiles basados en la paleta Gruvbox
      local function set_diffview_colors()
        local bg = vim.o.background
        local gruvbox = bg == "dark"
            and {
              -- Gruvbox dark - tonos muy sutiles
              add_bg = "#2e3b2e", -- verde apagado
              add_fg = "#b8bb26", -- gruvbox green
              delete_bg = "#3c2c2c", -- rojo apagado
              delete_fg = "#fb4934", -- gruvbox red
              change_bg = "#2e2e3b", -- azul apagado
              change_fg = "#83a598", -- gruvbox blue
              text_bg = "#4a4a2e", -- amarillo apagado (cambio inline)
              text_fg = "#fabd2f", -- gruvbox yellow
              -- Conflictos
              ours_bg = "#1d2a1d",
              theirs_bg = "#1d1d2a",
              base_bg = "#2a2a1d",
              dim = "#665c54", -- gruvbox bg4
            }
          or {
            -- Gruvbox light
            add_bg = "#d5e3c8",
            add_fg = "#79740e",
            delete_bg = "#e3c8c8",
            delete_fg = "#9d0006",
            change_bg = "#c8d5e3",
            change_fg = "#076678",
            text_bg = "#e3dfc8",
            text_fg = "#b57614",
            ours_bg = "#e0ebd0",
            theirs_bg = "#d0d0eb",
            base_bg = "#ebe0d0",
            dim = "#a89984",
          }

        -- Diff básico
        vim.api.nvim_set_hl(0, "DiffAdd", { bg = gruvbox.add_bg })
        vim.api.nvim_set_hl(
          0,
          "DiffDelete",
          { bg = gruvbox.delete_bg, fg = gruvbox.dim }
        )
        vim.api.nvim_set_hl(0, "DiffChange", { bg = gruvbox.change_bg })
        vim.api.nvim_set_hl(
          0,
          "DiffText",
          { bg = gruvbox.text_bg, bold = true }
        )

        -- Diffview específico
        vim.api.nvim_set_hl(0, "DiffviewDiffAdd", { bg = gruvbox.add_bg })
        vim.api.nvim_set_hl(0, "DiffviewDiffDelete", { bg = gruvbox.delete_bg })
        vim.api.nvim_set_hl(0, "DiffviewDiffChange", { bg = gruvbox.change_bg })
        vim.api.nvim_set_hl(
          0,
          "DiffviewDiffText",
          { bg = gruvbox.text_bg, bold = true }
        )
        vim.api.nvim_set_hl(
          0,
          "DiffviewDiffAddAsDelete",
          { bg = gruvbox.delete_bg, fg = gruvbox.dim }
        )
        vim.api.nvim_set_hl(0, "DiffviewDiffDeleteDim", { fg = gruvbox.dim })
      end

      set_diffview_colors()

      -- Reaplicar colores al cambiar colorscheme
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = set_diffview_colors,
      })

      require("diffview").setup({
        enhanced_diff_hl = true,
        view = {
          default = { layout = "diff2_horizontal" },
          merge_tool = {
            layout = "diff3_mixed",
            disable_diagnostics = true,
            winbar_info = true,
          },
          file_history = { layout = "diff2_horizontal" },
        },
        file_panel = {
          listing_style = "tree",
          win_config = { position = "left", width = 35 },
        },
        keymaps = {
          view = {
            {
              "n",
              "q",
              "<cmd>DiffviewClose<cr>",
              { desc = "Cerrar Diffview" },
            },
            {
              "n",
              "<leader>co",
              actions.conflict_choose("ours"),
              { desc = "Elegir OURS" },
            },
            {
              "n",
              "<leader>ct",
              actions.conflict_choose("theirs"),
              { desc = "Elegir THEIRS" },
            },
            {
              "n",
              "<leader>cb",
              actions.conflict_choose("base"),
              { desc = "Elegir BASE" },
            },
            {
              "n",
              "<leader>ca",
              actions.conflict_choose("all"),
              { desc = "Elegir ALL" },
            },
            {
              "n",
              "<leader>cn",
              actions.conflict_choose("none"),
              { desc = "Elegir NONE" },
            },
            {
              "n",
              "]x",
              actions.next_conflict,
              { desc = "Siguiente conflicto" },
            },
            {
              "n",
              "[x",
              actions.prev_conflict,
              { desc = "Anterior conflicto" },
            },
          },
          file_panel = {
            {
              "n",
              "q",
              "<cmd>DiffviewClose<cr>",
              { desc = "Cerrar Diffview" },
            },
            { "n", "j", actions.next_entry, { desc = "Siguiente entrada" } },
            { "n", "k", actions.prev_entry, { desc = "Anterior entrada" } },
            { "n", "<cr>", actions.select_entry, { desc = "Abrir diff" } },
            {
              "n",
              "s",
              actions.toggle_stage_entry,
              { desc = "Stage/Unstage" },
            },
            { "n", "S", actions.stage_all, { desc = "Stage all" } },
            { "n", "U", actions.unstage_all, { desc = "Unstage all" } },
            { "n", "R", actions.refresh_files, { desc = "Refresh" } },
          },
        },
        hooks = {
          diff_buf_read = function()
            vim.opt_local.wrap = false
            vim.opt_local.cursorline = true
          end,
        },
      })
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs_staged_enable = true,
      signs = {
        untracked = { text = "┋" },
        add = { text = "┃" },
        change = { text = "┃" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "┃" },
      },

      signs_staged = {
        untracked = { text = "┋" },
        add = { text = "┃" },
        change = { text = "┃" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "┃" },
      },

      on_attach = function(bufnr)
        local gitsigns = require("gitsigns")

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map("n", "]c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gitsigns.nav_hunk("next")
          end
        end, { desc = "Jump to next git [c]hange" })

        map("n", "[c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gitsigns.nav_hunk("prev")
          end
        end, { desc = "Jump to previous git [c]hange" })

        -- Visual mode
        map("v", "<leader>hs", function()
          gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "stage git hunk" })

        map("v", "<leader>hr", function()
          gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "reset git hunk" })

        -- Normal mode
        map(
          "n",
          "<leader>hs",
          gitsigns.stage_hunk,
          { desc = "git [s]tage hunk" }
        )
        map(
          "n",
          "<leader>hr",
          gitsigns.reset_hunk,
          { desc = "git [r]eset hunk" }
        )
        map(
          "n",
          "<leader>hS",
          gitsigns.stage_buffer,
          { desc = "git [S]tage buffer" }
        )
        map(
          "n",
          "<leader>hR",
          gitsigns.reset_buffer,
          { desc = "git [R]eset buffer" }
        )
        map(
          "n",
          "<leader>hp",
          gitsigns.preview_hunk,
          { desc = "git [p]review hunk" }
        )
        map(
          "n",
          "<leader>hb",
          gitsigns.blame_line,
          { desc = "git [b]lame line" }
        )
        map(
          "n",
          "<leader>hd",
          gitsigns.diffthis,
          { desc = "git [d]iff against index" }
        )
        map("n", "<leader>hD", function()
          gitsigns.diffthis("@")
        end, { desc = "git [D]iff against last commit" })

        -- Toggles
        map(
          "n",
          "<leader>tb",
          gitsigns.toggle_current_line_blame,
          { desc = "[T]oggle git show [b]lame line" }
        )
        map(
          "n",
          "<leader>tD",
          gitsigns.preview_hunk_inline,
          { desc = "[T]oggle git show [D]eleted" }
        )
      end,
    },
  },
}
