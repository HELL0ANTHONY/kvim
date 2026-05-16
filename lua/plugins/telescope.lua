local small_screen_columns = 140

local function responsive_layout(overrides)
  local layout = {
    width = 0.96,
    height = 0.92,
    flip_columns = small_screen_columns,
    horizontal = {
      width = 0.96,
      height = 0.92,
      preview_width = 0.65,
      preview_cutoff = small_screen_columns,
    },
    vertical = {
      width = 0.96,
      height = 0.92,
      preview_height = 0.55,
      preview_cutoff = 25,
      prompt_position = "bottom",
    },
  }

  if overrides then
    layout = vim.tbl_deep_extend("force", layout, overrides)
  end

  return layout
end

return {
  "nvim-telescope/telescope.nvim",
  branch = "master",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },
    "nvim-telescope/telescope-ui-select.nvim",
    "nvim-tree/nvim-web-devicons",
    "folke/trouble.nvim",
  },
  keys = {
    { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "[S]earch [H]elp" },
    { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "[S]earch [K]eymaps" },
    { "<home>", "<cmd>Telescope find_files<cr>", desc = "Search Files" },
    {
      "<leader>sf",
      "<cmd>Telescope find_files<cr>",
      desc = "[S]earch [F]iles",
    },
    {
      "<leader>ss",
      "<cmd>Telescope builtin<cr>",
      desc = "[S]earch [S]elect Telescope",
    },
    {
      "<leader>sw",
      "<cmd>Telescope grep_string<cr>",
      desc = "[S]earch current [W]ord",
    },
    {
      "<leader>sg",
      "<cmd>Telescope live_grep<cr>",
      desc = "[S]earch by [G]rep",
    },
    {
      "<leader>sl",
      function()
        require("telescope.builtin").live_grep({
          additional_args = { "--fixed-strings" },
        })
      end,
      desc = "[S]earch [L]iteral string",
    },
    {
      "<leader>sd",
      "<cmd>Telescope diagnostics<cr>",
      desc = "[S]earch [D]iagnostics",
    },
    { "<leader>sr", "<cmd>Telescope resume<cr>", desc = "[S]earch [R]esume" },
    {
      "<leader>s.",
      "<cmd>Telescope oldfiles<cr>",
      desc = "[S]earch Recent Files",
    },
    {
      "<leader><leader>",
      "<cmd>Telescope buffers<cr>",
      desc = "Find existing buffers",
    },
    {
      "<leader>/",
      function()
        require("telescope.builtin").current_buffer_fuzzy_find({
          layout_strategy = "flex",
          layout_config = responsive_layout(),
          previewer = false,
        })
      end,
      desc = "Fuzzily search in buffer",
    },
    {
      "<leader>sn",
      function()
        require("telescope.builtin").find_files({
          cwd = vim.fn.stdpath("config"),
        })
      end,
      desc = "[S]earch [N]eovim files",
    },
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local open_with_trouble = require("trouble.sources.telescope").open

    local default_layout = responsive_layout()
    local wide = responsive_layout({
      horizontal = {
        preview_width = 0.72,
      },
    })

    local grep_ignore = {
      "--glob=!package-lock.json",
      "--glob=!yarn.lock",
      "--glob=!pnpm-lock.yaml",
      "--glob=!go.sum",
      "--glob=!*.min.js",
      "--glob=!*.min.css",
      "--glob=!dist/*",
      "--glob=!node_modules/*",
      "--glob=!vendor/*",
      "--glob=!.git/*",
    }
    local vimgrep_args = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
    }
    for _, g in ipairs(grep_ignore) do
      table.insert(vimgrep_args, g)
    end

    telescope.setup({
      defaults = {
        prompt_prefix = "  ",
        selection_caret = "❯ ",
        path_display = { "truncate" },
        layout_strategy = "flex",
        layout_config = default_layout,
        vimgrep_arguments = vimgrep_args,
        mappings = {
          i = {
            ["<C-u>"] = false,
            ["<C-d>"] = false,
            ["<CR>"] = actions.select_default,
            ["<C-j>"] = actions.select_vertical,
            ["<C-k>"] = actions.select_horizontal,
            ["<C-t>"] = actions.select_tab,
            ["<C-q>"] = open_with_trouble, -- Enviar a Trouble
          },
          n = {
            ["q"] = actions.close,
            ["H"] = actions.select_default,
            ["J"] = actions.select_vertical,
            ["K"] = actions.select_horizontal,
            ["L"] = actions.select_tab,
            ["<C-q>"] = open_with_trouble,
          },
        },
      },
      pickers = {
        buffers = {
          sort_mru = true,
          previewer = false,
          ignore_current_buffer = true,
          initial_mode = "normal",
          mappings = { n = { ["dd"] = actions.delete_buffer } },
        },
        live_grep = { layout_config = wide },
        grep_string = { layout_config = wide },
        find_files = { layout_config = wide },
      },
      extensions = {
        ["ui-select"] = require("telescope.themes").get_dropdown(),
      },
    })
    pcall(telescope.load_extension, "fzf")
    pcall(telescope.load_extension, "ui-select")
  end,
}
