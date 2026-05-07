vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.opt_local.colorcolumn = "100"
  end,
})

-- Neovim 0.12: treesitter highlighting nativo
vim.api.nvim_create_autocmd("FileType", {
  desc = "Enable treesitter highlighting",
  callback = function(ev)
    local disable_treesitter = { sql = true, mysql = true }
    if disable_treesitter[vim.bo[ev.buf].filetype] then
      pcall(vim.treesitter.stop, ev.buf)
      return
    end

    pcall(vim.treesitter.start, ev.buf)
  end,
})
