return {
  -- Auto-close tags
  {
    "windwp/nvim-ts-autotag",
    ft = {
      "html",
      "markdown",
      "javascriptreact",
      "typescriptreact",
      "tsx",
      "jsx",
    },
    opts = {},
  },

  -- Auto-pairs (ligero)
  {
    "echasnovski/mini.pairs",
    event = "InsertEnter",
    opts = {},
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
-- return {
--   {
--     'windwp/nvim-ts-autotag',
--     ft = { 'html', 'markdown', 'javascriptreact', 'typescriptreact' },
--     opts = {
--       opts = {
--         enable_close = true,
--         enable_rename = true,
--         enable_close_on_slash = false,
--       },
--       per_filetype = {
--         html = {
--           enable_close = true,
--           enable_rename = true,
--         },
--         jsx = {
--           enable_close = true,
--           enable_rename = true,
--         },
--         tsx = {
--           enable_close = true,
--           enable_rename = true,
--         },
--         markdown = {
--           enable_close = true,
--           enable_rename = true,
--         },
--         javascript = {
--           enable_close = false,
--           enable_rename = false,
--         },
--         typescript = {
--           enable_close = false,
--           enable_rename = false,
--         },
--       },
--     },
--   },
-- }
