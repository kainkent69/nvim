-- The Plugin I made for myself and some convineit way to solve my habit of coding it
-- may have some vs-code refereces but is is just my way to ensure to code in both without needing so many other stupid thigs

local M = {}

M.setup = function()
  -- something
  local function add_newline_not_insert()
    vim.api.nvim_feedkeys('o<escape>', 'n', false)
  end
  -- the add new keymapping
  vim.keymap.set('n', 'gk', add_newline_not_insert, { desc = 'Add new line' })
end

return M
