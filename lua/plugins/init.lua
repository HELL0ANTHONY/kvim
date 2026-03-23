local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { import = "plugins.lsp" },
  { import = "plugins.ui" },
  { import = "plugins.telescope" },
  { import = "plugins.navigation" },
  { import = "plugins.lint" },
  { import = "plugins.conform" },
  { import = "plugins.blink" },
  { import = "plugins.fold" },
  { import = "plugins.gitconfig" },
  { import = "plugins.todo_comments" },
  { import = "plugins.misc" },
  { import = "plugins.copilot" },
  { import = "plugins.testing" },
  { import = "plugins.debug" },
  { import = "plugins.diagnostics-focus" },
}, {
  defaults = { lazy = true },
  change_detection = { notify = false },
  checker = { enabled = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "zipPlugin",
        "netrwPlugin",
        "tutor",
        "matchit",
        "matchparen",
        "spellfile",
      },
    },
  },
})
