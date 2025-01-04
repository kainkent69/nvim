local M = {}

M.getModes = function(mode, cb)
  for i = 1, #mode, 1 do
    local char = mode:sub(i, i)
    if cb.cb then
      cb.cb(char)
    end
  end
end

M.setup = function()
  vim.api.nvim_set_keymap('i', 'jk', '<Esc>', { desc = 'Go To Normal Mode' })
  vim.api.nvim_set_keymap('i', 'cmm`', '<Esc>gcc i', { desc = 'Toggle Comment' })
  vim.api.nvim_set_keymap('i', '<C-v>', '<Esc>p<Esc>i', { desc = 'Paste' })
  vim.api.nvim_set_keymap('i', '<C-c>', '<Esc>y <Esc> i', { desc = 'copy' })
  vim.api.nvim_set_keymap('i', '<C-a>', '<Esc>ggGVgg$', { desc = 'select all' })
  -- moving one line --
  -- local
  M.getModes('ni', {
    cb = function(mode)
      vim.api.nvim_set_keymap(mode, 'gjj', '<Esc>0VdkPi', { desc = 'move cursor up' })
      vim.api.nvim_set_keymap(mode, 'gj', '<Esc>0Vd<Esc>jPi', { desc = 'move cursor down' })
    end,
  })
end

return M
