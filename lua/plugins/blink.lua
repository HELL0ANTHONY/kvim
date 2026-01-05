-- plugins/blink.lua
return {
  {
    "saghen/blink.cmp",
    version = "*",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "rafamadriz/friendly-snippets",
      { "L3MON4D3/LuaSnip", version = "v2.*" },
      -- blink-copilot: sugerencias en menú de completado
      {
        "fang2hou/blink-copilot",
        opts = {
          max_completions = 1, -- Reducido porque también usamos ghost text
          max_attempts = 2,
          suggestion = {
            enabled = false, -- Ghost text lo maneja copilot.lua
          },
        },
      },
    },
    opts = {
      snippets = { preset = "luasnip" },
      sources = {
        default = { "lsp", "path", "snippets", "buffer", "copilot" },
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-copilot",
            score_offset = 100, -- Prioridad alta pero no dominante
            async = true, -- No bloquea el completado LSP
            transform_items = function(_, items)
              local CompletionItemKind =
                require("blink.cmp.types").CompletionItemKind
              local kind_idx = #CompletionItemKind + 1
              CompletionItemKind[kind_idx] = "Copilot"
              for _, item in ipairs(items) do
                item.kind = kind_idx
              end
              return items
            end,
          },
        },
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
      appearance = {
        use_nvim_cmp_as_default = true,
        kind_icons = {
          Copilot = "",
        },
      },
      -- Optimización de rendimiento
      completion = {
        list = { selection = { preselect = true, auto_insert = true } },
        menu = {
          draw = {
            columns = {
              { "kind_icon" },
              { "label", "label_description", gap = 1 },
              { "source_name" },
            },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
      },
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
