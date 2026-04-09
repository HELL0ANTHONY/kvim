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
          icon = { icon = "", color = "yellow" },
        },
        {
          "<leader>d",
          group = "[D]ebug",
          icon = { icon = "", color = "red" },
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
          icon = { icon = "", color = "green" },
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
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "mocha", -- latte | frappe | macchiato | mocha
      dim_inactive = { enabled = false },
      custom_highlights = function(colors)
        return {
          DiagnosticUnderlineError = { undercurl = true, sp = colors.red },
          DiagnosticUnderlineWarn = { undercurl = true, sp = colors.yellow },
          DiagnosticUnderlineInfo = { undercurl = true, sp = colors.sky },
          DiagnosticUnderlineHint = { undercurl = true, sp = colors.teal },
        }
      end,
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
        keywords = { "bold" },
        functions = { "bold" },
        types = { "bold", "italic" },
      },
      integrations = {
        gitsigns = true,
        indent_blankline = { enabled = true },
        lsp_trouble = true,
        mason = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        rainbow_delimiters = true,
        telescope = { enabled = true },
        treesitter = true,
        which_key = true,
      },
    },
    init = function()
      if vim.g.theme == "docs" then
        vim.cmd("colorscheme catppuccin")
      end
    end,
  },

  {
    "motaz-shokry/gruvbox.nvim",
    name = "gruvbox",
    lazy = false,
    priority = 1000,
    opts = {
      dim_inactive_windows = false,
      extend_background_behind_borders = false,
      styles = { bold = true, italic = true },
    },
    init = function()
      if vim.g.theme ~= "docs" then
        vim.cmd("colorscheme gruvbox-medium")
        -- Undercurl para diagnósticos LSP
        vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { undercurl = true, sp = "#FB4934" })
        vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { undercurl = true, sp = "#FABD2F" })
        vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { undercurl = true, sp = "#83A598" })
        vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { undercurl = true, sp = "#8EC07C" })
      end
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = function()
      local function has_terminal_win()
        for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
          local buf = vim.api.nvim_win_get_buf(w)
          if vim.bo[buf].buftype == "terminal" then
            return true
          end
        end
        return false
      end

      local function is_compact()
        local width = vim.api.nvim_win_get_width(0)
        -- small screen
        if vim.o.columns < 120 then
          return true
        end
        -- current window is narrow (vsplit or terminal taking space)
        local wins = vim.api.nvim_tabpage_list_wins(0)
        if #wins > 1 and width < vim.o.columns * 0.8 then
          return true
        end
        -- terminal open reduces usable space
        if has_terminal_win() and width < vim.o.columns * 0.9 then
          return true
        end
        return false
      end

      local function win_is_narrow(w)
        return vim.api.nvim_win_get_width(w or 0) < 60
      end

      local function file_icon()
        local ok, dev = pcall(require, "nvim-web-devicons")
        if not ok then
          return ""
        end
        local name, ext = vim.fn.expand("%:t"), vim.fn.expand("%:e")
        local icon = dev.get_icon(name, ext, { default = true })
        return icon and (icon .. " ") or ""
      end

      local function smart_filename()
        local name
        name = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":.")
        if name == "" then
          name = "[No Name]"
        end
        local modified = vim.bo.modified and " [󰦒]" or ""
        return file_icon() .. name .. modified
      end

      local diagnostics = {
        "diagnostics",
        sources = { "nvim_diagnostic" },
        sections = { "error", "warn", "info", "hint" },
        symbols = {
          error = " ", -- Error
          warn = " ", -- Warning
          info = " ", -- Info
          hint = "󰠠 ", -- Hint
        },
        colored = true,
        update_in_insert = false,
        always_visible = false,
      }

      local diff = {
        "diff",
        symbols = {
          added = " ", -- +
          modified = " ", -- ~
          removed = " ", -- -
        },
        colored = true,
        cond = function()
          return not win_is_narrow(0)
        end,
      }

      local function cursor_and_total()
        local l, c = vim.fn.line("."), vim.fn.col(".")
        local total = vim.api.nvim_buf_line_count(0)
        if win_is_narrow(0) then
          return string.format("%d/%d", l, total)
        end
        return string.format("󰉸 %d│󱥖 %d  %d", l, c, total)
      end

      local branch = {
        "branch",
        icon = "",
        color = { gui = "bold" },
        cond = function()
          return not is_compact()
        end,
      }

      return {
        options = {
          theme = "auto",
          globalstatus = false,
          section_separators = "",
          component_separators = "",
          disabled_filetypes = { statusline = {} },
          icons_enabled = true,
        },
        sections = {
          lualine_a = {},
          lualine_b = { branch, diff },
          lualine_c = { { smart_filename, padding = 1 } },
          lualine_x = { diagnostics },
          lualine_y = { { cursor_and_total, padding = 1 } },
          lualine_z = {},
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { { smart_filename } },
          lualine_x = { diagnostics },
          lualine_y = {},
          lualine_z = {},
        },
        extensions = { "quickfix", "fugitive", "man", "nvim-tree", "lazy" },
      }
    end,
  },

  {
    "lewis6991/ts-install.nvim",
    opts = {
      auto_install = true,
      ensure_install = {
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
        "terraform",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      },
    },
  },

  {
    "HiPhish/rainbow-delimiters.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local rd = require("rainbow-delimiters")
      vim.g.rainbow_delimiters = {
        strategy = {
          [""] = rd.strategy["global"],
          vim = rd.strategy["local"],
        },
        query = {
          [""] = "rainbow-delimiters",
          go = "rainbow-parens",
          html = "rainbow-parens",
          javascript = "rainbow-parens",
          javascriptreact = "rainbow-parens",
          jsx = "rainbow-parens",
          lua = "rainbow-blocks",
          tsx = "rainbow-parens",
          typescript = "rainbow-parens",
          typescriptreact = "rainbow-parens",
        },
      }
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    ft = { "yaml", "python", "tf", "hcl", "tpl" },
    opts = {
      scope = { enabled = false, show_start = false },
      whitespace = {
        highlight = { "CursorColumn", "Whitespace" },
        remove_blankline_trail = false,
      },
      indent = {
        highlight = { "CursorColumn", "Whitespace" },
        char = "",
      },
      exclude = {
        filetypes = {
          "help",
          "startify",
          "dashboard",
          "lazy",
          "neogitstatus",
          "NvimTree",
          "Trouble",
          "text",
        },
      },
    },
  },
}
