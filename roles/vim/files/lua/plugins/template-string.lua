return {
  'axelvc/template-string.nvim',
  config = function()
    require('template-string').setup {
      remove_template_string = true,
    }
  end,
}
