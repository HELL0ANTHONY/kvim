return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = "<M-y>",
          accept_word = "<M-w>",
          accept_line = "<M-j>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<M-c>",
        },
      },
      panel = { enabled = false },
      filetypes = {
        yaml = true,
        markdown = true,
        gitcommit = true,
        ["*"] = true,
      },
    },
  },
}

-- Algunas alternativas populares para accept que no conflictan con teclas comunes:
-- Opciones con Alt/Meta:
--
-- <M-y> - intuitivo (yes/accept)
-- <M-CR> - Alt+Enter
-- <M-;> - fácil de alcanzar
-- <M-Space> - cómodo
--
-- Opciones con Ctrl:
--
-- <C-y> - común para confirmar en muchos programas
-- <C-l> - si no usas para limpiar pantalla
-- <C-;>
--
-- Con Tab (si no usas para completado):
--
-- <Tab>
-- <S-Tab>
