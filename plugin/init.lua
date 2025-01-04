-- The Plugin I made for myself and some convineit way to solve my habit of coding it
-- may have some vs-code refereces but is is just my way to ensure to code in both without needing so many other stupid thigs

local M = {}

M.setup = function()
  vim.opt.expandtab = true
  -- Set shiftwidth and tabstop to 2 spaces
  vim.opt.shiftwidth = 2
  vim.opt.tabstop = 2

  -- Enable auto indentation
  vim.opt.autoindent = true

  -- Enable C-style indentation (optional)
  vim.opt.cindent = true

  -- something
  local function add_newline_not_insert()
    vim.api.nvim_feedkeys('o<escape>', 'n', false)
  end
  -- the add new keymapping
  vim.keymap.set('n', 'gk', add_newline_not_insert, { desc = 'Add new line' })
end

return M
