-- general
vim.opt.clipboard = { 'unnamed', 'unnamedplus' }
vim.opt.fileencodings = { 'utf-8', 'gb2312' }
vim.opt.foldlevel = 99
vim.opt.foldmethod = 'indent'
vim.opt.swapfile = false
vim.opt.undodir = '/tmp/vim'
vim.opt.undofile = true
vim.opt.updatetime = 300
vim.opt.wildignore = { '*/dist/*', '*/node_modules/*' }
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank {
      higroup = 'Visual',
      timeout = 300,
    }
  end,
})

-- search
vim.opt.ignorecase = true
vim.opt.wrapscan = false

-- tab
vim.g.markdown_recommended_style = false
vim.opt.expandtab = true
vim.opt.shiftround = true
vim.opt.shiftwidth = 0
vim.opt.tabstop = 2
