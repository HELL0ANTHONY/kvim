return {
  'sindrets/diffview.nvim',
  cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewToggleFiles', 'DiffviewFocusFiles' },
  keys = function()
    local map = function(key, cmd, desc)
      return {
        '<leader>' .. key,
        '<cmd>' .. cmd .. '<CR>',
        desc = desc,
      }
    end
    return {
      map(';do', 'DiffviewOpen', 'Open diff window'),
      map(';dc', 'DiffviewClose', 'Close diff window'),
      map(';de', 'DiffviewToggleFiles', 'Toggle diff sidebar'),
    }
  end,
}
