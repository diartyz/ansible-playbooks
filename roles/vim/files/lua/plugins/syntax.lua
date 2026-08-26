return {
  'sheerun/vim-polyglot',
  event = 'VeryLazy',
  init = function()
    vim.g.polyglot_disabled = { 'autoindent' }
  end,
  config = function() vim.g.vim_markdown_no_default_key_mappings = 1 end,
}
