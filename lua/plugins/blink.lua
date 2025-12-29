return {
  {
    "saghen/blink.cmp",
    version = "*",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "rafamadriz/friendly-snippets",
      { "L3MON4D3/LuaSnip", version = "v2.*" },
    },
    opts = {
      snippets = { preset = "luasnip" }, -- docs oficiales
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      keymap = {
        preset = "super-tab",
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
      },
      signature = { enabled = true },
      appearance = { use_nvim_cmp_as_default = true },
    },
    config = function(_, opts)
      local ok, ls = pcall(require, "luasnip")
      if ok then
        ls.config.setup({
          region_check_events = "CursorMoved,InsertEnter",
          delete_check_events = "TextChanged,InsertLeave",
        })
        pcall(require("luasnip.loaders.from_vscode").lazy_load)
      end
      require("blink.cmp").setup(opts)
    end,
  },
}
