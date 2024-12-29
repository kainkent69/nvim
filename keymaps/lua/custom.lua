local M = {}

M.setup = function()
  vim.api.nvim_set_keymap('i', 'jk', '<Esc>', { desc = 'Go To Normal Mode' })
  vim.api.nvim_set_keymap('i', 'cm`', '<Esc>gcc i', { desc = 'Toggle Comment' })
  vim.api.nvim_set_keymap('i', '<C-v>', '<Esc>P <Esc> i', { desc = 'Paste' })
  vim.api.nvim_set_keymap('i', '<C-c>', '<Esc>y <Esc> i', { desc = 'copy' })
  vim.api.nvim_set_keymap('i', '<C-a>', '<Esc>gg2vG$', { desc = 'select all' })

  -- moving one line --
  vim.api.nvim_set_keymap('i', 'gjj', '<Esc>0VdkPi', { desc = 'move cursor up' })
  vim.api.nvim_set_keymap('i', 'gj', '<Esc>0Vd<Esc>jPi', { desc = 'move cursor down' })
end

return M
