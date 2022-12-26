return {
  'nvim-tree/nvim-tree.lua',
  requires = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('nvim-tree').setup {
      prefer_startup_root = true,
      view = {
        width = 39,
      },
      renderer = {
        indent_width = 1,
        icons = {
          git_placement = 'signcolumn',
        },
      },
      update_focused_file = {
        enable = true,
        update_root = true,
      },
      diagnostics = {
        enable = true,
      },
      actions = {
        open_file = {
          quit_on_open = true,
        },
      },
      ui = {
        confirm = {
          trash = false,
        },
      },
      on_attach = function(bufnr)
        local api = require 'nvim-tree.api'
        local function opts(desc) return { desc = desc, buffer = bufnr } end

        vim.keymap.set('n', 'q', api.tree.close, opts 'Close')
        vim.keymap.set('n', '<c-e>', api.tree.close, opts 'Close')
        vim.keymap.set('n', '?', api.tree.toggle_help, opts 'Help')
        vim.keymap.set('n', 'H', api.tree.toggle_help, opts 'Help')
        vim.keymap.set('n', 'T', api.tree.toggle_git_clean_filter, opts 'Toggle Git Clean')
        vim.keymap.set('n', 'I', api.tree.toggle_gitignore_filter, opts 'Toggle Git Ignore')

        vim.keymap.set('n', '-', api.tree.change_root_to_parent, opts 'Up')
        vim.keymap.set('n', 'R', api.tree.reload, opts 'Refresh')
        vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts 'Close Directory')
        vim.keymap.set('n', 'l', api.node.open.edit, opts 'Open')
        vim.keymap.set('n', '<cr>', api.node.open.edit, opts 'Open')
        vim.keymap.set('n', 'o', api.node.open.preview, opts 'Open Preview')
        vim.keymap.set('n', '[c', api.node.navigate.git.prev, opts 'Prev Git')
        vim.keymap.set('n', ']c', api.node.navigate.git.next, opts 'Next Git')
        vim.keymap.set('n', ']e', api.node.navigate.diagnostics.next, opts 'Next Diagnostic')
        vim.keymap.set('n', '[e', api.node.navigate.diagnostics.prev, opts 'Prev Diagnostic')

        vim.keymap.set('n', 'e', api.fs.rename_basename, opts 'Rename: Basename')
        vim.keymap.set('n', 'r', api.fs.rename, opts 'Rename')
        vim.keymap.set('n', 'a', api.fs.create, opts 'Create')
        vim.keymap.set('n', 'c', api.fs.copy.node, opts 'Copy')
        vim.keymap.set('n', 'x', api.fs.cut, opts 'Cut')
        vim.keymap.set('n', 'p', api.fs.paste, opts 'Paste')
        vim.keymap.set('n', 'D', api.fs.trash, opts 'Trash')
        vim.keymap.set('n', 'Y', api.fs.copy.absolute_path, opts 'Copy Absolute Path')
        vim.keymap.set('n', 'yy', api.fs.copy.relative_path, opts 'Copy Relative Path')

        vim.keymap.set('n', 'm', api.marks.toggle, opts 'Toggle Bookmark')
        vim.keymap.set('n', 'b', api.marks.bulk.move, opts 'Move Bookmarked')
      end,
    }
    vim.keymap.set('n', '<c-e>', '<cmd>NvimTreeFocus<cr>')
  end,
}
