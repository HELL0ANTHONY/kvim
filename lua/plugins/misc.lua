return {
  {
    'windwp/nvim-ts-autotag',
    ft = { 'html', 'markdown', 'javascriptreact', 'typescriptreact' },
    opts = {
      opts = {
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = false,
      },
      per_filetype = {
        html = {
          enable_close = true,
          enable_rename = true,
        },
        jsx = {
          enable_close = true,
          enable_rename = true,
        },
        tsx = {
          enable_close = true,
          enable_rename = true,
        },
        markdown = {
          enable_close = true,
          enable_rename = true,
        },
        javascript = {
          enable_close = false,
          enable_rename = false,
        },
        typescript = {
          enable_close = false,
          enable_rename = false,
        },
      },
    },
  },
}
