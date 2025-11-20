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
          far.toggle_instance { instanceName = 'far' }
        end
      end,
      mode = { 'n', 'x' },
      desc = 'focus far',
    },
    {
      '<leader>f',
      function() require('grug-far').toggle_instance { instanceName = 'far' } end,
      mode = { 'n', 'x' },
      desc = 'toggle far',
    },
  },
  config = function()
    require('grug-far').setup {
      folding = { enabled = true },
      openTargetWindow = { preferredLocation = 'prev' },
      prefills = vim.tbl_extend('force', { filesFilter = '!.git/', flags = '--hidden -i' }, vim.g.far_prefills or {}),
      staticTitle = 'far',
      transient = true,
      keymaps = {
        abort = false,
        applyNext = false,
        applyPrev = false,
        close = { n = 'q' },
        gotoLocation = { n = '<enter>' },
        help = { n = '?' },
        historyAdd = false,
        historyOpen = { n = '<leader>u' },
        nextInput = '<tab>',
        openLocation = { n = '<c-s>' },
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
      end,
    })
  end,
}
