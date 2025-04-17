local vector = require 'custom.vector'
-- The Plugin I made for myself and some convineit way to solve my habit of coding it
-- may have some vs-code refereces but is is just my way to ensure to code in both without needing so many other stupid thigs

local M = {}
M.setup = function()
  -- Indenting
  -- Func

  IndentFunc = function(width, tab, auto)
    vim.opt_local.expandtab = tab -- Use tabs
    vim.opt_local.shiftwidth = tonumber(width)
    vim.opt_local.tabstop = tonumber(width)
    vim.opt_local.softtabstop = tonumber(width)
    vim.opt_local.autoindent = auto
  end
  -- For Everything Else
  vim.api.nvim_create_autocmd('FileType', {
    callback = function()
      return IndentFunc(4, false, true)
    end,
  })

  -- For Any filetype
  CreateForFileType = function(pattern, width, tab, auto)
    vim.api.nvim_create_autocmd('FileType', {
      pattern = pattern, -- Replace with another filetype
      callback = function()
        return IndentFunc(width, tab, auto)
      end,
    })
  end

  --  For Clang
  CreateForFileType('c', 4, false, true)
  -- For Golang
  CreateForFileType('go', 4, false, false)
end

return M
