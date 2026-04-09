return {
  'MagicDuck/grug-far.nvim',
  keys = {
    {
      '<c-s>',
      function()
        local far = require 'grug-far'
        if far.has_instance 'far' then
          far.get_instance('far'):open()
        else
          far.open()
        end
      end,
      mode = 'n',
      desc = 'open far',
    },
    {
      '<c-s>',
      function() require('grug-far').with_visual_selection() end,
      mode = 'x',
      desc = 'open far with visual selection',
    },
  },
  config = function()
    require('grug-far').setup {
      folding = { enabled = false },
      instanceName = 'far',
      openTargetWindow = { preferredLocation = 'prev' },
      prefills = vim.tbl_extend('force', { filesFilter = '!.git/', flags = '--hidden -i' }, vim.g.far_prefills or {}),
      staticTitle = 'far',
      keymaps = {
        abort = false,
        applyNext = false,
        applyPrev = false,
        close = { n = 'q' },
        gotoLocation = { n = '<c-s>' },
        help = { n = '?' },
        historyAdd = false,
        historyOpen = { n = '<leader>u' },
        nextInput = '<tab>',
        openLocation = false,
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
        vim.keymap.set({ 'i', 'n' }, '<c-j>', function()
          vim.api.nvim_command 'stopinsert'
          require('grug-far').get_instance('far'):goto_next_match()
        end, { buffer = true, desc = 'far go to next match' })
        vim.keymap.set({ 'i', 'n' }, '<c-k>', function()
          vim.api.nvim_command 'stopinsert'
          require('grug-far').get_instance('far'):goto_prev_match()
        end, { buffer = true, desc = 'far go to prev match' })
        vim.keymap.set('n', '<enter>', function()
          require('grug-far').get_instance('far'):open_location()
          require('grug-far').get_instance('far'):hide()
        end, { buffer = true, desc = 'far open' })
      end,
    })
  end,
}
