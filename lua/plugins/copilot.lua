return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = '<M-l>', -- Alt+l para aceptar
          accept_word = '<M-w>', -- Alt+w para aceptar palabra
          accept_line = '<M-j>', -- Alt+j para aceptar línea
          next = '<M-]>',
          prev = '<M-[>',
          dismiss = '<M-c>',
        },
      },
      panel = { enabled = false },
      filetypes = {
        yaml = true,
        markdown = true,
        gitcommit = true,
        ['*'] = true,
      },
    },
  },
}
