return {
  "L3MON4D3/LuaSnip",
  config = function()
    local ls = require "luasnip"
    -- si usás friendly-snippets o loaders, inicializalos acá si querés
    -- require("luasnip.loaders.from_vscode").lazy_load()

    local js_ts = require "snippets.js_ts"

    -- Lista única de filetypes a cubrir
    local target_fts = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
    }

    -- Registrar el mismo snippet para todos los FTs
    js_ts.register(target_fts)
  end,
}
