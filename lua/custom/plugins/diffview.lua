return {
  'sindrets/diffview.nvim',
  cmd = { 'DiffviewOpen' },
  keys = function()
    return {
      { '<leader>od', '<cmd>:DiffviewOpen<CR>', desc = '[o]pen [d]iff' },
      { '<leader>dc', '<cmd>:DiffviewClose<CR>', desc = '[d]iff [c]lose' },
      { '<leader>dt', '<cmd>:DiffviewToggleFiles<CR>', desc = '[d]iff [t]oggle' },
    }
  end,
  config = function()
    require('diffview').setup {
      view = {
        merge_tool = {
          layout = 'diff3_mixed', -- :h diffview-config-view.x.layout
          disable_diagnostics = true,
          winbar_info = true,
        },
      },
    }
  end,
}

--[[ 
  # Conflictos
  :h diffview-merge-tool
  COMMAND: DiffviewOpen
  OURS -> left
  THEIRS -> right

  Note: 
    - (!): this indicates that the file has not yet been opened, and the number of conflicts is unknown.
    - (check mark): If the sign is a check mark, this indicates that there are no more conflicts in the file.
  Move:
    You can jump between conflict markers with `]x` and `[x`.

    Additionally there are mappings for operating directly on the conflict markers:
    • `<leader>co`: Choose the OURS version of the conflict.
    • `<leader>ct`: Choose the THEIRS version of the conflict.
    • `<leader>cb`: Choose the BASE version of the conflict.
    • `<leader>ca`: Choose all versions of the conflict (effectively
      just deletes the markers, leaving all the content).
    • `dx`: Choose none of the versions of the conflict (delete the conflict region).
]]
