local function feed_keys(input)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(input, true, false, true), 'mi', true)
end

local function is_module_available(name)
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
  feed_keys = feed_keys,
  is_module_available = is_module_available,
  load_local_config = load_local_config,
  make_repeatable_move_pair = make_repeatable_move_pair,
  set_last_move = set_last_move,
  set_repeat = set_repeat,
}
