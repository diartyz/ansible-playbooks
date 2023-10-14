return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = 'nvim-tree/nvim-web-devicons',
  opts = {
    options = {
      indicator = { style = 'underline' },
      max_name_length = 99,
      max_prefix_length = 99,
      show_buffer_close_icons = false,
      show_buffer_icons = false,
      tab_size = 0,
    },
  },
}
