return {
  'nvim-tree/nvim-tree.lua',
  dependencies = 'nvim-tree/nvim-web-devicons',
  keys = {
    { '<c-e>', '<cmd>NvimTreeFocus<cr>' },
  },
  opts = {
    actions = {
      open_file = {
        quit_on_open = true,
      },
    },
    diagnostics = {
      enable = true,
    },
    filesystem_watchers = {
      enable = false,
    },
    filters = {
      git_ignored = false,
    },
    prefer_startup_root = true,
    renderer = {
      indent_width = 1,
      icons = {
        git_placement = 'signcolumn',
      },
    },
    respect_buf_cwd = true,
    sync_root_with_cwd = true,
    ui = {
      confirm = {
        remove = false,
      },
    },
    update_focused_file = {
      enable = true,
      update_root = true,
    },
    view = {
      width = 39,
    },
    on_attach = function(bufnr)
      local api = require 'nvim-tree.api'
      local function opts(desc) return { desc = desc, buffer = bufnr } end

      vim.keymap.set('n', 'q', api.tree.close, opts 'Close')
      vim.keymap.set('n', '<c-e>', api.tree.close, opts 'Close')
      vim.keymap.set('n', 'g?', api.tree.toggle_help, opts 'Help')
      vim.keymap.set('n', 'I', api.tree.toggle_gitignore_filter, opts 'Toggle Git Ignore')
      vim.keymap.set('n', 'R', api.tree.reload, opts 'Refresh')

      vim.keymap.set('n', '<c-h>', api.tree.collapse_all, opts 'Collapse')
      vim.keymap.set('n', 'H', api.tree.change_root_to_parent, opts 'Up')
      vim.keymap.set('n', 'L', api.tree.change_root_to_node, opts 'CD')
      vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts 'Close Directory')
      vim.keymap.set('n', 'l', api.node.open.preview, opts 'Open Preview')
      vim.keymap.set('n', 'o', api.node.open.edit, opts 'Open')
      vim.keymap.set('n', '<cr>', api.node.open.edit, opts 'Open')
      vim.keymap.set('n', '[c', api.node.navigate.git.prev, opts 'Prev Git')
      vim.keymap.set('n', ']c', api.node.navigate.git.next, opts 'Next Git')
      vim.keymap.set('n', '<c-j>', api.node.navigate.diagnostics.next, opts 'Next Diagnostic')
      vim.keymap.set('n', '<c-k>', api.node.navigate.diagnostics.prev, opts 'Prev Diagnostic')

      vim.keymap.set('n', 'a', api.fs.create, opts 'Create')
      vim.keymap.set('n', 'r', api.fs.rename_basename, opts 'Rename: Basename')
      vim.keymap.set('n', 'cc', api.fs.rename, opts 'Rename')
      vim.keymap.set('n', 'dd', api.fs.cut, opts 'Cut')
      vim.keymap.set('n', 'yy', api.fs.copy.node, opts 'Copy')
      vim.keymap.set('n', 'p', api.fs.paste, opts 'Paste')
      vim.keymap.set('n', 'D', api.fs.remove, opts 'Delete')
      vim.keymap.set('n', 'cf', api.fs.copy.relative_path, opts 'Copy Relative Path')
      vim.keymap.set('n', 'cp', api.fs.copy.absolute_path, opts 'Copy Absolute Path')

      vim.keymap.set('n', 'C', api.marks.clear, opts 'Clear all marks')
      vim.keymap.set('n', 'm', api.marks.bulk.move, opts 'Move Bookmarked')
      vim.keymap.set('n', 'v', api.marks.toggle, opts 'Toggle Bookmark')
    end,
  },
}
