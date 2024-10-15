return {
  'sindrets/diffview.nvim',
  cmd = { 'DiffviewOpen' },
  keys = function()
    return {
      { '<leader>gd', '<cmd>:DiffviewOpen<CR>', desc = '[g]it [d]iffview' },
      { '<leader>gq', '<cmd>:DiffviewClose<CR>', desc = '[g]it diffview [q]uit' },
      { '<leader>gf', '<cmd>:DiffviewToggleFiles<CR>', desc = '[g]it diff [f]iles' },
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
    [x previous conflict
    ]x next conflict
]]
