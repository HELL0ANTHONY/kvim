vim.opt.termguicolors = true
vim.opt.wildmenu = true
vim.g.have_nerd_font = true -- ← CAMBIAR a true si tienes Nerd Font

vim.opt.number = false
vim.opt.relativenumber = false
vim.opt.wrap = false
vim.opt.linebreak = true
vim.opt.mouse = ""
vim.opt.pumheight = 10
vim.opt.showmode = false

vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
end)

vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.o.splitbelow = true
vim.o.splitright = true
vim.opt.colorcolumn = "80"
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.softtabstop = 2
vim.opt.tabstop = 2
vim.opt.list = true
vim.opt.listchars = { tab = "⇥ ", trail = "+", space = "·", nbsp = "⣿" }
vim.opt.inccommand = "split"
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.cmdheight = 1

-- Netrw desactivado (usas oil)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
