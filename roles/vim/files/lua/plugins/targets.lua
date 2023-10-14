return {
  'wellle/targets.vim',
  event = 'VeryLazy',
  config = function()
    vim.g.targets_seekRanges = 'cc cr cb cB lc ac Ac lr lb ar ab lB Ar aB Ab AB'
    vim.api.nvim_create_autocmd('User', {
      group = vim.api.nvim_create_augroup('targets', { clear = true }),
      pattern = 'targets#mappings#user',
      callback = function()
        vim.fn['targets#mappings#extend'] {
          a = {
            argument = {
              {
                o = '[({[]',
                c = '[]})]',
                s = ',',
              },
            },
          },
          b = {
            pair = {
              {
                o = '(',
                c = ')',
              },
            },
          },
        }
      end,
    })
  end,
}
