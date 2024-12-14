local which_keyOptions = {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
  keys = {
    {
      '<leader>ed',
      function()
        require('which-key').show { global = false }
      end,
      desc = 'Buffer Local Keymaps (which-key)',
    },
  },
}

local M = {}

M.setup = function()
  return which_keyOptions
end
