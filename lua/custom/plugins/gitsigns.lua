return {
  'lewis6991/gitsigns.nvim',
  opts = {
    signs = {
      untracked = {
        text = '┋',
        -- hl = "GitSignsUntracked",
        -- numhl = "GitSignsUntrackedNr",
        -- linehl = "GitSignsUntrackedLn",
      },

      add = {
        text = '▎',
        -- hl = "GitSignsAdd",
        -- numhl = "GitSignsAddNr",
        -- linehl = "GitSignsAddLn",
      },

      change = {
        text = '┃',
        -- hl = "GitSignsChange",
        -- numhl = "GitSignsChangeNr",
        -- linehl = "GitSignsChangeLn",
      },

      delete = {
        text = '',
        -- hl = "GitSignsDelete",
        -- numhl = "GitSignsDeleteNr",
        -- linehl = "GitSignsDeleteLn",
      },

      topdelete = {
        text = '',
        -- hl = "GitSignsDelete",
        -- numhl = "GitSignsDeleteNr",
        -- linehl = "GitSignsDeleteLn",
      },

      changedelete = {
        text = '┃',
        -- hl = "GitSignsChange",
        -- numhl = "GitSignsChangeNr",
        -- linehl = "GitSignsChangeLn",
      },
    },
  },
}

-- local plugin = {
--   "lewis6991/gitsigns.nvim",
--   event = "BufEnter",
--   cmd = "Gitsigns",
-- }
-- plugin.config = function()
--   local icons = require("george.icons")
--
--
--   require("gitsigns").setup({
--
--     },
--     watch_gitdir = {
--       interval = 1000,
--       follow_files = true,
--     },
--     attach_to_untracked = true,
--     current_line_blame = false,
--     current_line_blame_formatter = "<author> | <author_time:%d-%m-%Y> | <summary>",
--     update_debounce = 200,
--     max_file_length = 40000,
--     preview_config = {
--       border = "rounded",
--       style = "minimal",
--       relative = "cursor",
--       row = 0,
--       col = 1,
--     },
--   })
-- end
--
-- return plugin
