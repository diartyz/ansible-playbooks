return function(file)
  local projectConfig = vim.fn.findfile(file, '.;')
  if vim.fn.filereadable(projectConfig) == 1 then vim.cmd('source ' .. projectConfig) end
end
