return {
  'chrisgrieser/nvim-origami',
  event = 'VeryLazy',
  opts = {
    -- usa LSP con fallback a TS/indent
    useLspFoldsWithTreesitterFallback = true,
    pauseFoldsOnSearch = true,
    foldtext = { enabled = true, diagnosticsCount = true, gitsignsCount = true },
    autoFold = { enabled = true, kinds = { 'comment', 'imports' } },
  },
  init = function()
    vim.opt.foldlevel = 99
    vim.opt.foldlevelstart = 99
  end,
}
