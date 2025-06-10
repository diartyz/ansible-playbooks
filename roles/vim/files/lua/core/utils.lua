local function feedKeys(input)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(input, true, false, true), 'mi', true)
end

local function isModuleAvailable(name)
  if package.loaded[name] then return true end
  for _, searcher in ipairs(package.searchers or package.loaders) do
    local loader = searcher(name)
    if type(loader) == 'function' then
      package.preload[name] = loader
      return true
    end
  end
  return false
end

local function loadLocalConfig(file)
  local localConfig = vim.fn.findfile(file, '.;')
  if vim.fn.filereadable(localConfig) == 1 then vim.cmd('source ' .. localConfig) end
end

return {
  feedKeys = feedKeys,
  isModuleAvailable = isModuleAvailable,
  loadLocalConfig = loadLocalConfig,
}
