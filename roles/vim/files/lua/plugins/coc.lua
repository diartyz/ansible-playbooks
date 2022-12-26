return {
  'neoclide/coc.nvim',
  branch = 'release',
  requires = 'SirVer/ultisnips',
  config = function()
    vim.g.coc_global_extensions = {
      'coc-tabnine',
      'coc-snippets',
      'coc-tsserver',
      'coc-eslint',
      'coc-prettier',
      'coc-graphql',
      'coc-sumneko-lua',
      'coc-vimlsp',
    }
    vim.g.UltiSnipsExpandTrigger = '<c-;>'
    vim.keymap.set('i', '<c-space>', vim.fn['coc#refresh'], { expr = true })
    vim.keymap.set('i', '<tab>', function()
      if vim.call 'coc#pum#visible' then
        vim.call 'coc#pum#confirm'
      else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<tab>', true, true, true), 'in', true)
      end
    end)
    vim.keymap.set('n', '<c-j>', '<Plug>(coc-diagnostic-next)')
    vim.keymap.set('n', '<c-k>', '<Plug>(coc-diagnostic-prev)')
    vim.keymap.set('n', '<leader>.', '<Plug>(coc-codeaction-cursor)')
    vim.keymap.set('n', '<leader>gd', '<Plug>(coc-references)')
    vim.keymap.set('n', '<leader>r', '<Plug>(coc-rename)')
    vim.keymap.set('n', 'gd', '<Plug>(coc-definition)')
    vim.keymap.set('n', 'gh', function() vim.fn.CocActionAsync 'doHover' end)
    vim.keymap.set('n', 'gi', '<Plug>(coc-implementation)')
    vim.keymap.set('n', 'go', function() vim.fn.CocActionAsync('runCommand', 'editor.action.organizeImport') end)
    vim.keymap.set('n', 'gp', '<Plug>(coc-format)')
    vim.keymap.set({ 'o', 'x' }, 'af', '<Plug>(coc-funcobj-a)')
    vim.keymap.set({ 'o', 'x' }, 'if', '<Plug>(coc-funcobj-i)')
  end,
}
