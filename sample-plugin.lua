local function insert_text(text)
  local current_buf = vim.api.nvim_get_current_buf()
  local current_line, _ = unpack(vim.api.nvim_win_get_cursor(0))

  vim.api.nvim_buf_set_lines(current_buf, current_line - 1, current_line - 1, false, { text })
end

-- format the code
vim.api.nvim_create_user_command('FormatCode', function()
  vim.api.nvim_feedkeys('<leader>sfe', 'n', false)
end, {})
vim.api.nvim_create_user_command('RunC', function()
  vim.cmd 'i'
  insert_text 'hello fucking world'
end, {})

vim.keymap.set('n', 'ee', function()
  vim.print 'Hello Mars'
end, { desc = 'Hello World' })
