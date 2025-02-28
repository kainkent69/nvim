local function change_default_indent(flags, values)
  local allowedFlags = flaglist['indent']
  for _, flag in ipairs(flags) do
    if not vector.includes(allowedFlags, flag) then
      vim.notify(flag .. ' is not a valid options for ' .. 'indent')
    else
      local _value = values[flag]

      if flag == 'size' then
        if _value == nil then
          vim.notify(vim.inspect(_value) .. ' is not valid value for indent --size')
        else
          vim.notify(vim.inspect(_value) .. ' is valid indent --size')
          vim.opt.shiftwidth = _value
          vim.opt.tabstop = _value
          vim.opt.expandtab = _value
          vim.opt.softtabstop = _value
          vim.notify('tabsize is now ' .. _value, vim.log.levels.INFO)
        end
      else
        vim.notify('flag: ' .. flag .. ' is invalid', vim.log.levels.ERROR)
      end
    end
  end
end

change_default_indent(jk, values)
