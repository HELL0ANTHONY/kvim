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

-- Cargar ui-select cuando se llame vim.ui.select
vim.api.nvim_create_autocmd("LspAttach", {
  once = true,
  callback = function()
    pcall(function()
      require("telescope").load_extension("ui-select")
    end)
  end,
})

-- Highlight personalizado para Oil.nvim
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "OilNormal", { bg = "#1d2021" })
    vim.api.nvim_set_hl(
      0,
      "OilWinbar",
      { fg = "#d65d0e", bg = "#1d2021", bold = true }
    )
  end,
})

vim.api.nvim_set_hl(0, "OilNormal", { bg = "#1d2021" })
vim.api.nvim_set_hl(
  0,
  "OilWinbar",
  { fg = "#458588", bg = "#1d2021", bold = true }
)
