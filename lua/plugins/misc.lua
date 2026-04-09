return {
  -- Auto-close tags (deshabilitado: incompatible con Neovim 0.12)
  -- {
  --   "windwp/nvim-ts-autotag",
  --   ft = { "html", "markdown", "javascriptreact", "typescriptreact", "tsx", "jsx" },
  --   opts = {},
  -- },

  -- Auto-pairs (ligero)
  {
    "echasnovski/mini.pairs",
    event = "InsertEnter",
    config = function()
      require("mini.pairs").setup({})

      local function t(keys)
        return vim.api.nvim_replace_termcodes(keys, true, true, true)
      end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "markdown" },
        callback = function()
          vim.keymap.set("i", "`", function()
            local col = vim.fn.col(".") - 1
            local line = vim.fn.getline(".")
            local before = line:sub(1, col)

            if before:match("``$") then
              return t("`<CR><CR>```<Up>")
            end

            return t("``<Left>")
          end, { buffer = true, expr = true, noremap = true })
        end,
      })
    end,
  },

  -- Surround
  {
    "echasnovski/mini.surround",
    event = "VeryLazy",
    opts = {
      mappings = {
        add = "sa", -- sa{motion}{char}
        delete = "sd", -- sd{char}
        replace = "sr", -- sr{old}{new}
        find = "sf",
        find_left = "sF",
        highlight = "sh",
        update_n_lines = "sn",
      },
    },
  },

  -- Comment (gcc, gc{motion})
  {
    "echasnovski/mini.comment",
    event = "VeryLazy",
    opts = {},
  },
}
