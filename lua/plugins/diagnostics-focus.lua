-- Diagnostics Focus Mode
-- Modes: 1=minimal (signs only), 2=current line, 3=all virtual text, 4=float on hover
return {
  {
    'dgagn/diagflow.nvim', -- Optional: inline diagnostics at cursor
    event = 'LspAttach',
    opts = {
      enable = false, -- Start disabled, toggle with focus mode
      scope = 'line',
      padding_top = 0,
      padding_right = 1,
      show_sign = false,
      placement = 'top',
      format = function(d)
        local icons = { ' ', ' ', ' ', '󰠠 ' }
        return icons[d.severity] .. d.message
      end,
    },
  },
  -- {
  -- 'folke/trouble.nvim', -- Better diagnostics list
  -- cmd = 'Trouble',
  -- keys = {
  --   { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnostics (Trouble)' },
  --   { '<leader>xd', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Buffer diagnostics' },
  --   { '<leader>xq', '<cmd>Trouble qflist toggle<cr>', desc = 'Quickfix list' },
  -- },
  -- opts = {
  --   auto_close = true,
  --   focus = true,
  --   modes = {
  --     diagnostics = { auto_open = false, auto_preview = false },
  --   },
  -- },
  -- },
  {
    dir = '.', -- Virtual plugin for focus mode logic
    name = 'diagnostics-focus',
    event = 'LspAttach',
    config = function()
      local M = {}
      M.mode = 1 -- Start in minimal mode (building)
      M.modes = {
        { name = 'Minimal', vt = false, float = false, diagflow = false },
        { name = 'Current Line', vt = 'current_line', float = false, diagflow = false },
        { name = 'Diagflow', vt = false, float = false, diagflow = true },
        { name = 'Float on Hover', vt = false, float = true, diagflow = false },
        { name = 'Full', vt = true, float = false, diagflow = false },
      }

      local float_augroup = vim.api.nvim_create_augroup('DiagFloatHover', { clear = true })
      local float_enabled = false

      local function setup_float_hover(enable)
        vim.api.nvim_clear_autocmds { group = float_augroup }
        float_enabled = enable
        if enable then
          vim.api.nvim_create_autocmd('CursorHold', {
            group = float_augroup,
            callback = function()
              vim.diagnostic.open_float(nil, { focus = false, scope = 'cursor' })
            end,
          })
        end
      end

      function M.apply_mode()
        local cfg = M.modes[M.mode]
        -- Virtual text config
        ---@type boolean|table
        local vt_config
        if cfg.vt == 'current_line' then
          vt_config = { current_line = true }
        else
          vt_config = cfg.vt
        end
        vim.diagnostic.config { virtual_text = vt_config }
        -- Float on hover
        setup_float_hover(cfg.float)
        -- Diagflow (if installed)
        local ok, diagflow = pcall(require, 'diagflow')
        if ok then
          if cfg.diagflow then
            diagflow.enable()
          else
            diagflow.disable()
          end
        end
      end

      function M.cycle()
        M.mode = M.mode % #M.modes + 1
        M.apply_mode()
        vim.notify('Diagnostics: ' .. M.modes[M.mode].name, vim.log.levels.INFO)
      end

      function M.set(mode)
        if mode >= 1 and mode <= #M.modes then
          M.mode = mode
          M.apply_mode()
          vim.notify('Diagnostics: ' .. M.modes[M.mode].name, vim.log.levels.INFO)
        end
      end

      -- Keymaps
      vim.keymap.set('n', '<leader>df', M.cycle, { desc = '[D]iagnostics [F]ocus cycle' })
      vim.keymap.set('n', '<leader>d1', function()
        M.set(1)
      end, { desc = 'Diagnostics: Minimal' })
      vim.keymap.set('n', '<leader>d2', function()
        M.set(2)
      end, { desc = 'Diagnostics: Current Line' })
      vim.keymap.set('n', '<leader>d3', function()
        M.set(3)
      end, { desc = 'Diagnostics: Diagflow' })
      vim.keymap.set('n', '<leader>d4', function()
        M.set(4)
      end, { desc = 'Diagnostics: Float Hover' })
      vim.keymap.set('n', '<leader>d5', function()
        M.set(5)
      end, { desc = 'Diagnostics: Full' })

      -- Quick toggles
      vim.keymap.set('n', '<leader>dh', function()
        local cur = vim.diagnostic.config().virtual_text
        vim.diagnostic.config { virtual_text = not cur }
        vim.notify('Virtual text: ' .. (not cur and 'ON' or 'OFF'))
      end, { desc = '[D]iagnostics toggle virtual text' })

      -- Initialize
      M.apply_mode()

      -- Expose globally for statusline integration
      _G.DiagFocus = M
    end,
  },
}
