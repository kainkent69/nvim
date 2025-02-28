local function includes(_table, value)
  for _, v in ipairs(_table) do
    if v == value then
      return true
    end
  end
end

local function keys(_table)
  local _keys = {}
  for key, _ in ipairs(_table) do
    _keys:insert(key)
  end
  return _keys
end

local function values(_table)
  local _values = {}
  for _, value in ipairs(_table) do
    _values:insert(value)
  end
  return _values
end

local M = {}

M.includes = includes
M.keys = keys
M.values = values

return M
