return {
  'MagicDuck/grug-far.nvim',
  keys = { { '<c-s>', mode = { 'n', 'x' } } },
  config = function()
    require('grug-far').setup {
      openTargetWindow = { preferredLocation = 'prev' },
      staticTitle = 'far',
      keymaps = {
        abort = false,
        applyNext = false,
        applyPrev = false,
        close = { n = 'q' },
        gotoLocation = { n = '<enter>' },
        help = { n = '?' },
        historyAdd = false,
        historyOpen = { n = '<localleader>u' },
        nextInput = '<tab>',
        openLocation = { n = '<localleader>o' },
        openNextLocation = false,
        openPrevLocation = false,
        pickHistoryEntry = { n = '<enter>' },
        prevInput = '<s-tab>',
        previewLocation = { n = 'gq' },
        qflist = false,
        refresh = { n = '<localleader>f' },
        replace = { n = '<localleader>r' },
        swapEngine = false,
        swapReplacementInterpreter = false,
        syncFile = false,
        syncLine = false,
        syncLocations = { n = '<localleader>s' },
        syncNext = false,
        syncPrev = false,
        toggleShowCommand = '<c-t>',
      },
    }
    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('grug-far-keymap', { clear = true }),
      pattern = { 'grug-far' },
      callback = function()
        vim.keymap.set(
          { 'i', 'n' },
          '<c-j>',
          function() require('grug-far').get_instance('far'):goto_next_match() end,
          { buffer = true }
        )
        vim.keymap.set(
          { 'i', 'n' },
          '<c-k>',
          function() require('grug-far').get_instance('far'):goto_prev_match() end,
          { buffer = true }
        )
        vim.keymap.set('i', '<c-c>', function()
          require('grug-far').get_instance('far'):close()
          vim.api.nvim_command 'stopinsert'
        end, { buffer = true })
        vim.keymap.set('i', '<c-s>', function()
          require('grug-far').get_instance('far'):hide()
          vim.api.nvim_command 'stopinsert'
        end, { buffer = true })
      end,
    })
    vim.keymap.set({ 'n', 'x' }, '<c-s>', function() require('grug-far').toggle_instance { instanceName = 'far' } end)
  end,
}
