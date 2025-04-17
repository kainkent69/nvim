-- - comment
-- -@param _table table the table to check
-- -@param value any  is the value to check if exists in `table`
---@return boolean if exists
local function includes(_table, value)
  for _, v in ipairs(_table) do
    if v == value then
      return true
    end
  end
  return false
end

---comment
---@param _table table is the table to get the keys for
---@return table the new table containing only keys
local function keys(_table)
  local _keys = {}
  for key, _ in ipairs(_table) do
    _keys:insert(key)
  end
  return _keys
end

---comment
---@param _table table the table to loop through
---@return table the newly created table that contains only value
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
