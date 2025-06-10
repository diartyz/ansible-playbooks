return {
  'iamcco/markdown-preview.nvim',
  cmd = 'MarkdownPreview',
  ft = 'markdown',
  build = function() vim.fn['mkdp#util#install']() end,
}
