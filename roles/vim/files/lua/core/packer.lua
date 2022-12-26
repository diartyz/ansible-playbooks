return function(plugins)
  return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    for _, plugin in pairs(plugins) do
      use(plugin)
    end
  end)
end
