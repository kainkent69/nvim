local M = {

  getModes = function(mode, cb)
    for i = 1, #mode, 1 do
      local char = mode:sub(i, i)
      if cb.cb then
        cb.cb(char)
      end
    end
  end,
}
-- parse strings into modes

return M
