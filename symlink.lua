local function symlink(url as string) 
  return "~/.config/nvim/" + url
end

return symlink
