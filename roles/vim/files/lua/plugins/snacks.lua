return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    explorer = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    notifier = { enabled = true },
    picker = {
      sources = {
        explorer = {
          auto_close = true,
          hidden = true,
          layout = { hidden = { 'input' } },
        },
      },
      win = { input = { keys = { ['<Esc>'] = { 'close', mode = { 'n', 'i' } } } } },
    },
    quickfile = { enabled = true },
    scroll = { enabled = true },
    words = { enabled = true },
  },
  keys = {
    { '<c-e>', function() Snacks.picker.explorer() end, desc = 'lsp_symbols' },
    { '<c-t>', function() Snacks.picker.lsp_symbols() end, desc = 'LSP Symbols' },
    { '[[', function() Snacks.words.jump(-vim.v.count1) end, desc = 'Prev Reference', mode = { 'n', 't' } },
    { ']]', function() Snacks.words.jump(vim.v.count1) end, desc = 'Next Reference', mode = { 'n', 't' } },
    { 'gD', function() Snacks.picker.lsp_declarations() end, desc = 'Goto Declaration' },
    { 'gI', function() Snacks.picker.lsp_implementations() end, desc = 'Goto Implementation' },
    { 'gd', function() Snacks.picker.lsp_definitions() end, desc = 'Goto Definition' },
    { 'gi', function() Snacks.picker.lsp_incoming_calls() end, desc = 'C[a]lls Incoming' },
    { 'gy', function() Snacks.picker.lsp_type_definitions() end, desc = 'Goto T[y]pe Definition' },
  },
}
