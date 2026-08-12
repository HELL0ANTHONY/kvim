return {
  {
    "folke/which-key.nvim",
    event = "VimEnter",
    opts = {
      icons = { mappings = true, keys = {} },
      spec = {
        {
          "<leader>c",
          group = "[C]ustom",
          icon = { icon = "", color = "yellow" },
        },
        {
          "<leader>d",
          group = "[D]ebug",
          icon = { icon = "", color = "red" },
        },
        { "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
        {
          "<leader>j",
          group = "[J]ump",
          icon = { icon = "󱕘", color = "yellow" },
        },
        {
          "<leader>t",
          group = "[T]est",
          icon = { icon = "󰙨", color = "azure" },
        },
        {
          "<leader>s",
          group = "[S]earch",
          icon = { icon = "", color = "green" },
        },
        {
          "<leader>x",
          group = "Trouble e[X]plorer",
          icon = { icon = "󰝖", color = "purple" },
        },
        {
          "gr",
          group = "LSP [G]oto/[R]efactor",
          icon = { icon = "", color = "blue" },
        },
      },
    },
  },

  {
    "sainnhe/gruvbox-material",
    lazy = false,
    priority = 1000,
    init = function()
      vim.g.gruvbox_material_enable_bold = 1
      vim.g.gruvbox_material_enable_italic = 1
      vim.g.gruvbox_material_diagnostic_virtual_text = "highlighted"
      vim.g.gruvbox_material_foreground = "material"
      vim.g.gruvbox_material_background = "medium"
      vim.g.gruvbox_material_better_performance = 1
      vim.cmd("colorscheme gruvbox-material")
      vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { undercurl = true, sp = "#FB4934" })
      vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { undercurl = true, sp = "#FABD2F" })
      vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { undercurl = true, sp = "#83A598" })
      vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { undercurl = true, sp = "#8EC07C" })
    end,
  },

  {
    "romus204/tree-sitter-manager.nvim",
    lazy = false,
    config = function(_, opts)
      require("tree-sitter-manager").setup(opts)
    end,
    opts = {
      auto_install = true,
      ensure_installed = {
        "bash",
        "css",
        "go",
        "gomod",
        "gosum",
        "gowork",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "php",
        "python",
        "terraform",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      },
      highlight = false,
    },
  },
}
