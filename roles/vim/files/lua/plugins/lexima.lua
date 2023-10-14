return {
  'cohama/lexima.vim',
  event = 'InsertEnter',
  config = function()
    vim.g.lexima_accept_pum_with_enter = 0
    vim.g.lexima_map_escape = ''
  end,
}
