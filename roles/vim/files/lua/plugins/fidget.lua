return {
  'j-hui/fidget.nvim',
  config = function()
    require('fidget').setup {
      timer = {
        fidget_decay = 300,
        task_decay = 300,
      },
      window = {
        blend = 0,
      },
    }
  end,
}
