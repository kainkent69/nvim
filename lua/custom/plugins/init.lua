local helpers = require 'custom.helpers'
local M = {}
M.setup = function()
  -- moving one line --
  -- local
  local map = vim.api.nvim_set_keymap

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

  map('n', '<C-/>', 'gcc', {
    desc = 'Comment Toggle',
  })

  map('v', '<C-/>', 'gc', {
    desc = 'Comment Toggle',
  })

  map('i', '<C-/>', '<Esc>gcci', {
    desc = 'Comment Toggle',
  })

  -- navigating the content
  map('i', '<C-k>', '<up>', { desc = 'Move Upward' })
  map('i', '<C-j>', '<down>', { desc = 'Move Downward' })
  -- move the content back
  map('i', '<C-L>', '<right>', { desc = 'Move Forward' })
  map('i', '<C-H>', '<left>', { desc = 'Move Backward' })
  -- users options
  require('custom.plugins.userOptions').setup()
  -- for godot
  local set = false
  local projectFile = vim.fn.getcwd() .. 'project-godot'
  if projectFile and set then
    vim.fn.serverstart './godohost'
  end
end

return M
