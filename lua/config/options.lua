vim.opt.termguicolors = true
vim.opt.wildmenu = true
vim.g.have_nerd_font = true

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.linebreak = true
vim.opt.mouse = ""
vim.opt.pumheight = 10
vim.opt.showmode = false

if
  vim.fn.has("wsl") == 1
  and vim.fn.executable("clip.exe") == 1
  and vim.fn.executable("powershell.exe") == 1
then
  local paste_from_windows_clipboard = {
    "powershell.exe",
    "-NoLogo",
    "-NoProfile",
    "-Command",
    "[Console]::OutputEncoding = [Text.UTF8Encoding]::new(); "
      .. "(Get-Clipboard -Raw) -replace \"`r`n\", \"`n\" -replace \"`r\", \"`n\"",
  }

  vim.g.clipboard = {
    name = "WslClipboard",
    copy = {
      ["+"] = { "clip.exe" },
      ["*"] = { "clip.exe" },
    },
    paste = {
      ["+"] = paste_from_windows_clipboard,
      ["*"] = paste_from_windows_clipboard,
    },
    cache_enabled = 0,
  }
end

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
vim.opt.swapfile = false

-- Neovim 0.12: bordes globales para floating windows y popup menu
vim.opt.winborder = "single"
vim.opt.pumborder = "single"

-- Netrw desactivado
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
