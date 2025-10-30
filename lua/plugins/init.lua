local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system { 'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', '--branch=stable', lazypath }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  { import = 'plugins.lsp', lazy = false },
  { import = 'plugins.ui' },
  { import = 'plugins.telescope' },
  { import = 'plugins.navigation' },
  { import = 'plugins.lint' },
  { import = 'plugins.conform' },
  { import = 'plugins.blink' },
  { import = 'plugins.fold' },
  { import = 'plugins.gitconfig' },
  { import = 'plugins.lua_snip' },
  { import = 'plugins.todo_comments' },
}, {
  defaults = { lazy = true },
  change_detection = {
    notify = false,
  },
  checker = { enabled = false },
  performance = {
    rtp = {
      disabled_plugins = { 'gzip', 'tarPlugin', 'tohtml', 'zipPlugin', 'netrwPlugin', 'tutor' },
    },
  },
})
