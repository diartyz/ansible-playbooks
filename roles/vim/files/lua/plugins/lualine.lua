return {
  'nvim-lualine/lualine.nvim',
  dependencies = 'nvim-tree/nvim-web-devicons',
  event = 'VeryLazy',
  opts = {
    options = {
      component_separators = '',
      section_separators = '',
    },
    sections = {
      lualine_a = {},
      lualine_b = { 'branch', 'diff', 'diagnostics' },
      lualine_c = { '%f' },
      lualine_x = { 'searchcount', 'encoding' },
      lualine_y = { 'filetype' },
      lualine_z = {},
    },
    inactive_sections = {
      lualine_c = { '%f' },
      lualine_x = {},
    },
  },
}
