return {
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'williamboman/mason.nvim', opts = { ui = { keymaps = { toggle_help = '?' } } } },
    { 'williamboman/mason-lspconfig.nvim', config = true },
    {
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      opts = {
        ensure_installed = {
          'clangd',
          'emmet-language-server',
          'eslint-lsp',
          'graphql-language-service-cli',
          'json-lsp',
          'lua-language-server',
          'prettierd',
          'rust-analyzer',
          'shfmt',
          'stylua',
          'typescript-language-server',
          'vim-language-server',
        },
      },
    },
  },
  config = function()
    -- lsp config
    vim.lsp.config('clangd', vim.g.clangd_config or {})
    vim.lsp.enable('clangd', not vim.g.disable_clangd)
    vim.lsp.config('lua_ls', {
      root_markers = {
        '.git',
        '.luacheckrc',
        '.luarc.json',
        '.luarc.jsonc',
        '.stylua.toml',
        'lazy-lock.json',
        'selene.toml',
        'selene.yml',
        'stylua.toml',
      },
      settings = {
        Lua = {
          diagnostics = {
            globals = { 'vim' },
          },
        },
      },
    })
    vim.lsp.config('jsonls', {
      settings = {
        json = {
          schemas = {
            {
              fileMatch = { 'package.json' },
              url = 'https://json.schemastore.org/package.json',
            },
            {
              fileMatch = { 'tsconfig*.json' },
              url = 'https://json.schemastore.org/tsconfig.json',
            },
            {
              fileMatch = { '.babelrc', '.babelrc.json', 'babel.config.json' },
              url = 'https://json.schemastore.org/babelrc.json',
            },
            {
              fileMatch = { '.eslintrc', '.eslintrc.json' },
              url = 'https://json.schemastore.org/eslintrc.json',
            },
            {
              fileMatch = { '.prettierrc', '.prettierrc.json', 'prettier.config.json' },
              url = 'https://json.schemastore.org/prettierrc.json',
            },
          },
        },
      },
    })
    vim.lsp.config('ts_ls', {
      init_options = {
        preferences = {
          importModuleSpecifierPreference = 'project-relative',
          jsxAttributeCompletionStyle = 'none',
        },
      },
    })

    -- mapping
    vim.keymap.set('n', '<f2>', vim.lsp.buf.rename, { desc = 'lsp rename' })
    vim.keymap.set('n', '<leader>.', vim.lsp.buf.code_action, { desc = 'lsp code action' })
    vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, { desc = 'lsp rename' })
    vim.keymap.set('n', 'gh', vim.lsp.buf.hover, { desc = 'lsp hover' })
    local pos_equal = function(p1, p2)
      local r1, c1 = (table.unpack or unpack)(p1)
      local r2, c2 = (table.unpack or unpack)(p2)
      return r1 == r2 and c1 == c2
    end
    vim.keymap.set('n', '<c-j>', function()
      local pos = vim.api.nvim_win_get_cursor(0)
      vim.diagnostic.jump { count = 1, float = true, severity = vim.diagnostic.severity.ERROR }
      local pos2 = vim.api.nvim_win_get_cursor(0)
      if pos_equal(pos, pos2) then vim.diagnostic.jump { count = 1, float = true } end
    end, { desc = 'next diagnostic' })
    vim.keymap.set('n', '<c-k>', function()
      local pos = vim.api.nvim_win_get_cursor(0)
      vim.diagnostic.jump { count = -1, float = true, severity = vim.diagnostic.severity.ERROR }
      local pos2 = vim.api.nvim_win_get_cursor(0)
      if pos_equal(pos, pos2) then vim.diagnostic.jump { count = -1, float = true } end
    end, { desc = 'prev diagnostic' })
    local is_module_available = require('core.utils').is_module_available
    vim.keymap.set('n', '<c-t>', function()
      if is_module_available 'telescope.builtin' then
        require('telescope.builtin').lsp_document_symbols { symbol_width = 39 }
      else
        vim.lsp.buf.document_symbol()
      end
    end, { desc = 'lsp document symbols' })
    vim.keymap.set('n', 'gD', function()
      if is_module_available 'fzf-lua' then
        require('fzf-lua').lsp_declarations()
      else
        vim.lsp.buf.declaration()
      end
    end, { desc = 'lsp declaration' })
    vim.keymap.set('n', 'gI', function()
      if is_module_available 'telescope.builtin' then
        require('telescope.builtin').lsp_implementations()
      else
        vim.lsp.buf.implementation()
      end
    end, { desc = 'lsp implementation' })
    vim.keymap.set('n', 'gd', function()
      if is_module_available 'telescope.builtin' then
        require('telescope.builtin').lsp_definitions()
      else
        vim.lsp.buf.definition()
      end
    end, { desc = 'lsp definition' })
    vim.keymap.set('n', 'gi', function()
      if is_module_available 'telescope.builtin' then
        require('telescope.builtin').lsp_incoming_calls()
      else
        vim.lsp.buf.incoming_calls()
      end
    end, { desc = 'lsp incoming calls' })
    vim.keymap.set('n', 'gy', function()
      if is_module_available 'telescope.builtin' then
        require('telescope.builtin').lsp_type_definitions()
      else
        vim.lsp.buf.type_definition()
      end
    end, { desc = 'lsp type definition' })
    vim.keymap.set(
      'n',
      'yoh',
      function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end,
      { desc = 'toggle inlay hint' }
    )

    -- autocmd
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'cpp',
      callback = function()
        vim.keymap.set('n', 'go', '<cmd>LspClangdSwitchSourceHeader<cr>', { desc = 'switch source header' })
      end,
    })
    local typescript = require 'plugins/typescript'
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'typescript,typescriptreact',
      callback = function()
        vim.keymap.set('n', 'go', function()
          typescript.add_missing_imports()
          typescript.remove_unused_imports()
          typescript.sort_imports()
        end, { desc = 'organize imports' })
      end,
    })

    -- virtual text
    vim.diagnostic.config { virtual_text = true }
    vim.lsp.inlay_hint.enable()
  end,
}
