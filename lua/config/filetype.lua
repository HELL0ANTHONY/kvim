vim.filetype.add {
  extension = {
    env = 'dotenv',
    tpl = 'smarty',
  },
  filename = {
    ['.env'] = 'dotenv',
    ['index.tpl'] = 'smarty',
  },
  pattern = {
    ['%.env%.[%w_.-]+'] = 'dotenv',
    ['%.tpl$'] = 'smarty',
  },
}

vim.treesitter.language.register('bash', 'dotenv')
