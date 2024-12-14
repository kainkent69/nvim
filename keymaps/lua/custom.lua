local M = {}

M.setup = function()
  vim.keymap.set('i', '<C-/>', function()
    vim.api.nvim_feedkeys('gcc', 'n', false)
  end, { desc = 'Toggle Comment' })
end

return M
