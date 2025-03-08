local vector = require 'custom.vector'
-- The Plugin I made for myself and some convineit way to solve my habit of coding it
-- may have some vs-code refereces but is is just my way to ensure to code in both without needing so many other stupid thigs

local M = {}
M.setup = function()
  vim.opt.expandtab = true
  vim.opt.autoindent = true
  vim.opt.smartindent = true
  -- Enable C-style indentation (optional)
  local commandList = { 'indent', 'language-options' }
  local flaglist = { indent = { 'size' } }

  local function change_default_indent(flags, values)
    vim.notify('called indent ' .. vim.inspect(flags) .. ' ' .. vim.inspect(values))
    local allowedFlags = flaglist['indent']
    for _, flag in ipairs(flags) do
      if not vector.includes(allowedFlags, flag) then
        vim.notify(flag .. ' is not a valid options for ' .. 'indent')
      else
        local _value = values[_]
        if flag == 'size' then
          if tonumber(_value) == nil then
            vim.notify(vim.inspect(_value) .. ' is not valid value for indent --size')
          else
            vim.notify(vim.inspect(tonumber(_value)) .. ' is valid indent --size')
            vim.opt.shiftwidth = tonumber(_value)
            vim.opt.tabstop = tonumber(_value)
            vim.opt.softtabstop = tonumber(_value)
            vim.notify('tabsize is now ' .. _value, vim.log.levels.INFO)
          end
        else
          vim.notify('flag: ' .. flag .. ' is invalid for indent', vim.log.levels.ERROR)
        end
      end
    end
  end

  local commands = { indent = change_default_indent }
  local function executeUserOptions(sub, flags, values)
    if not vector.includes(commandList, sub) then
      vim.notify(vim.inspect(sub) .. ' is not part of command list')
      return
    end

    function test(b)
      if b == true then
        return 'true'
      end
      return 'false'
    end

    vim.notify('flags count ' .. vim.inspect(flags))
    vim.notify('flags next ' .. vim.inspect(test(next(flags))))
    if next(flags) then
      for flagName, flagValue in ipairs(flags) do
        local allowedFlags = flaglist[sub]
        vim.notify(vim.inspect(test(allowedFlags)) .. ' are the flags for the ' .. vim.inspect(sub))
        local func = commands[sub]
        if func ~= nil then
          func(flags, values)
        end
      end
    end
  end

  function parseValue(arg)
    local list = vim.split(arg, '/', { trimempty = true })

    if #list > 1 then
      return list
    end
    return list[1]
  end

  vim.api.nvim_create_user_command('UsersOptions', function(opts)
    local args = vim.split(opts.args, ' ', { trimempty = true })
    local subcommand = nil
    local flags = {}
    local values = {}
    local current = 1

    if #args > 0 and not args[1]:match '(^--)' then
      vim.notify('has no sub ' .. args[1])
      subcommand = args[1]
      current = 2
    end

    while current <= #args do
      local arg = args[current]
      local nextArg = args[current + 1]
      if arg:match '(^--)' then
        local flagName = arg:sub(3)
        table.insert(flags, flagName)
        current = current + 1
      else
        local value = parseValue(arg)
        if value ~= nil then
          table.insert(values, value)
        end
        current = current + 1
      end
    end

    -- execute the options
    executeUserOptions(subcommand, flags, values)
    for _, flagValue in ipairs(flags) do
      vim.notify('a new flag ' .. vim.inspect(flagValue))
      vim.notify('value' .. vim.inspect(values[_]))
    end

    local level = vim.log.levels.debug
    vim.notify('sub command ' .. vim.inspect(subcommand), level)
    vim.notify('flags ' .. vim.inspect(flags) .. ' ', level)
    vim.notify('values ' .. vim.inspect(values), level)
  end, { nargs = '*' })
end
return M
