return {
  'MagicDuck/grug-far.nvim',
  keys = {
    {
      '<c-s>',
      function() require('grug-far').toggle_instance { instanceName = 'far' } end,
      mode = { 'n', 'x' },
    },
  },
  config = function()
    require('grug-far').setup {
      openTargetWindow = { preferredLocation = 'prev' },
      prefills = vim.g.far_prefills,
      staticTitle = 'far',
      keymaps = {
        abort = false,
        applyNext = false,
        applyPrev = false,
        close = { n = 'q' },
        gotoLocation = false,
        help = { n = '?' },
        historyAdd = false,
        historyOpen = { n = '<leader>u' },
        nextInput = '<tab>',
        openLocation = { n = 'p' },
        openNextLocation = false,
        openPrevLocation = false,
        pickHistoryEntry = { n = '<enter>' },
        prevInput = '<s-tab>',
        previewLocation = false,
        qflist = false,
        refresh = { n = '<leader>f' },
        replace = { n = '<leader>r' },
        swapEngine = false,
        swapReplacementInterpreter = false,
        syncFile = false,
        syncLine = false,
        syncLocations = { n = '<leader>s' },
        syncNext = false,
        syncPrev = false,
        toggleShowCommand = '<c-t>',
      },
    }

    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('grug-far-keymap', { clear = true }),
      pattern = 'grug-far',
      callback = function()
        vim.keymap.set('i', '<c-c>', function()
          vim.api.nvim_command 'stopinsert'
          require('grug-far').get_instance('far'):close()
        end, { buffer = true, desc = 'far close' })
        vim.keymap.set('i', '<c-s>', function()
          vim.api.nvim_command 'stopinsert'
          require('grug-far').get_instance('far'):hide()
        end, { buffer = true, desc = 'far hide' })
        vim.keymap.set('n', '<enter>', function()
          local instance = require('grug-far').get_instance 'far'
          instance:goto_location()
          instance:hide()
        end, { buffer = true, desc = 'far go to location and hide' })
        vim.keymap.set({ 'i', 'n' }, '<c-j>', function()
          vim.api.nvim_command 'stopinsert'
          require('grug-far').get_instance('far'):goto_next_match()
        end, { buffer = true, desc = 'far go to next match' })
        vim.keymap.set({ 'i', 'n' }, '<c-k>', function()
          vim.api.nvim_command 'stopinsert'
          require('grug-far').get_instance('far'):goto_prev_match()
        end, { buffer = true, desc = 'far go to prev match' })
      end,
    })
  end,
}
