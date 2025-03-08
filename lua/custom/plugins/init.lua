local helpers = require 'custom.helpers'
local M = {}
M.setup = function()
  -- moving one line --
  -- local
  local map = vim.api.nvim_set_keymap
  local vimmap = vim.keymap

  vimmap.set('n', '<leader>g1', function()
    vim.api.nvim_feedkeys(':tabn 1', 'n', false)
  end, { desc = 'goto tab 1' })

  vimmap.set('n', '<leader>g2', function()
    vim.api.nvim_feedkeys(':tabn 2', 'n', false)
  end, { desc = 'goto tab 2' })

  vimmap.set('n', '<leader>g3', function()
    vim.api.nvim_feedkeys(':tabn 2', 'n', false)
  end, { desc = 'goto tab 3' })

  -- cursor and other things
  helpers.getModes('nivx', {
    cb = function(mode)
      map(mode, 'jk', '<Esc>', { desc = 'Go To Normal Mode' })
      map(mode, '<leader>mu', '<Esc>0VdkP', { desc = 'move cursor up' })
      map(mode, '<leader>mb', '<Esc>0Vd<Esc>jP', { desc = 'move cursor down' })
      map(mode, '<C-v>', '<Esc>p<Esc>i', { desc = 'Paste' })
      map(mode, '<C-c>', '<Esc>y<Esc> i', { desc = 'copy' })
      map(mode, '<C-a>', '<Esc>ggGVgg$', { desc = 'select all' })
    end,
  })

  -- users options

  require('custom.plugins.userOptions').setup()
end
return M
