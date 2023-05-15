return function(plugins)
  return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    for _, plugin in pairs(plugins) do
      if type(plugin) == 'table' then
        for _, item in pairs(plugin) do
          use(item)
        end
      else
        use(plugin)
      end
    end
  end)
end
