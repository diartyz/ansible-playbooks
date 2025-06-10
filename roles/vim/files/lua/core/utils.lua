local function ensure_installed(packages)
  local registry = require 'mason-registry'
  registry.refresh(function()
    for _, name in pairs(packages) do
      local pkg = registry.get_package(name)
      if not registry.is_installed(name) then
        pkg:install()
      else
        local installed_version = pkg:get_installed_version()
        local latest_version = pkg:get_latest_version()
        if latest_version ~= installed_version and pkg:is_installable { version = latest_version } then
          pkg:install { version = latest_version }
        end
      end
    end
  end)
end

local function feed_keys(input)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(input, true, false, true), 'mi', true)
end

local function is_module_available(name)
  if package.loaded[name] then return true end
  for _, searcher in ipairs(package.loaders or package.searchers) do
    local loader = searcher(name)
    if type(loader) == 'function' then
      package.preload[name] = loader
      return true
    end
  end
  return false
end

local function load_local_config(file)
  local localConfig = vim.fn.findfile(file, '.;')
  if vim.fn.filereadable(localConfig) == 1 then vim.cmd('source ' .. localConfig) end
end

local function make_repeatable_move_pair(next, prev)
  if not is_module_available 'nvim-treesitter.textobjects.repeatable_move' then return next, prev end
  return require('nvim-treesitter.textobjects.repeatable_move').make_repeatable_move_pair(next, prev)
end

local function set_last_move(fn)
  if not is_module_available 'nvim-treesitter.textobjects.repeatable_move' then return end
  require('nvim-treesitter.textobjects.repeatable_move').set_last_move(fn, { forward = true })
end

local function set_repeat(input) vim.fn['repeat#set'](vim.api.nvim_replace_termcodes(input, true, false, true)) end

return {
  ensure_installed = ensure_installed,
  feed_keys = feed_keys,
  is_module_available = is_module_available,
  load_local_config = load_local_config,
  make_repeatable_move_pair = make_repeatable_move_pair,
  set_last_move = set_last_move,
  set_repeat = set_repeat,
}
