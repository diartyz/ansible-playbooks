local configs = {}

local function run_config()
  for _, config in pairs(configs) do
    config()
  end
end

local function use(args)
  if type(args) == 'string' then
    vim.fn['plug#'](args)
    return
  end
  local opts = vim.empty_dict()
  for key, value in pairs(args) do
    if key == 1 then
      goto continue
    elseif key == 'run' then
      opts['do'] = value
    elseif key == 'config' or key == 'setup' then
      configs[#configs + 1] = value
    elseif key ~= 'requires' then
      opts[key] = value
    end
    ::continue::
  end
  vim.fn['plug#'](args[1], opts)
  if not args.requires then return end
  if type(args.requires) == 'string' or not vim.tbl_islist(args.requires) then
    use(args.requires)
    return
  end
  for i = 1, #args.requires do
    use(args.requires[i])
  end
end

return function(plugins)
  vim.call 'plug#begin'

  for _, plugin in pairs(plugins) do
    use(plugin)
  end

  vim.call 'plug#end'

  require 'impatient'

  run_config()
end
