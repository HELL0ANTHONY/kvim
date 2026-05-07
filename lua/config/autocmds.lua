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

-- tree-sitter-manager installs parsers; we start highlighting manually so
-- filetype aliases like javascriptreact and dotenv keep working.
vim.api.nvim_create_autocmd("FileType", {
  desc = "Enable Tree-sitter highlighting",
  callback = function(ev)
    local disable_treesitter = { sql = true, mysql = true }
    if disable_treesitter[vim.bo[ev.buf].filetype] then
      pcall(vim.treesitter.stop, ev.buf)
      return
    end

    pcall(vim.treesitter.start, ev.buf)
  end,
})
