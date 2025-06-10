local function isModuleAvailable(name)
  if package.loaded[name] then
    return true
  else
    for _, searcher in ipairs(package.searchers or package.loaders) do
      local loader = searcher(name)
      if type(loader) == 'function' then
        package.preload[name] = loader
        return true
      end
    end
    return false
  end
end

local function loadLocalConfig(file)
  local projectConfig = vim.fn.findfile(file, '.;')
  if vim.fn.filereadable(projectConfig) == 1 then vim.cmd('source ' .. projectConfig) end
end

return {
  isModuleAvailable = isModuleAvailable,
  loadLocalConfig = loadLocalConfig,
}
