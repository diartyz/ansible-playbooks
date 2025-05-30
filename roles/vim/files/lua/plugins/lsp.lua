return {
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'ray-x/lsp_signature.nvim', lazy = true },
    { 'williamboman/mason.nvim', config = true },
    { 'williamboman/mason-lspconfig.nvim', config = true },
    {
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      opts = {
        auto_update = true,
        ensure_installed = {
          'black',
          'clangd',
          'emmet-language-server',
          'eslint-lsp',
          'graphql-language-service-cli',
          'json-lsp',
          'lua-language-server',
          'prettierd',
          'python-lsp-server',
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
    local augroup = vim.api.nvim_create_augroup('LspFormatting', { clear = true })
    local isModuleAvailable = require('core/utils').isModuleAvailable
    local function lsp_config(overrides)
      local on_attach = overrides and overrides.on_attach
      return vim.tbl_extend('force', overrides or {}, {
        capabilities = isModuleAvailable 'cmp_nvim_lsp' and require('cmp_nvim_lsp').default_capabilities() or nil,
        on_attach = function(client, bufnr)
          if on_attach then on_attach(client, bufnr) end
          require('lsp_signature').on_attach(nil, bufnr)
        end,
      })
    end
    local function disable_format(client)
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end
    local function merge_config(name, config)
      vim.lsp.config(name, lsp_config(vim.tbl_extend('force', vim.lsp.config[name], config or {})))
    end

    vim.lsp.config('*', lsp_config())
    merge_config('clangd', vim.g.clangd_config)
    vim.lsp.enable('clangd', not vim.g.disable_clangd)
    merge_config('ts_ls', {
      init_options = {
        preferences = {
          importModuleSpecifierPreference = 'project-relative',
          jsxAttributeCompletionStyle = 'none',
        },
      },
      on_attach = disable_format,
    })
    merge_config('lua_ls', {
      settings = {
        Lua = {
          diagnostics = {
            globals = { 'vim' },
          },
          format = {
            enable = false,
          },
        },
      },
    })
    merge_config('jsonls', {
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
    merge_config('pylsp', {
      on_attach = disable_format,
    })

    local typescript = require 'plugins/typescript'
    local pos_equal = function(p1, p2)
      local r1, c1 = (table.unpack or unpack)(p1)
      local r2, c2 = (table.unpack or unpack)(p2)
      return r1 == r2 and c1 == c2
    end

    vim.keymap.set('n', '<c-j>', function()
      local pos = vim.api.nvim_win_get_cursor(0)
      vim.diagnostic.goto_next { severity = vim.diagnostic.severity.ERROR }
      local pos2 = vim.api.nvim_win_get_cursor(0)
      if pos_equal(pos, pos2) then vim.diagnostic.goto_next() end
    end)
    vim.keymap.set('n', '<c-k>', function()
      local pos = vim.api.nvim_win_get_cursor(0)
      vim.diagnostic.goto_prev { severity = vim.diagnostic.severity.ERROR }
      local pos2 = vim.api.nvim_win_get_cursor(0)
      if pos_equal(pos, pos2) then vim.diagnostic.goto_prev() end
    end)
    vim.keymap.set('n', '<c-t>', function()
      if isModuleAvailable 'telescope.builtin' then
        require('telescope.builtin').lsp_document_symbols { symbol_width = 39 }
      else
        vim.lsp.buf.document_symbol()
      end
    end)
    vim.keymap.set('n', '<f2>', vim.lsp.buf.rename)
    vim.keymap.set('n', '<leader>.', vim.lsp.buf.code_action)
    vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename)
    vim.keymap.set('n', 'gd', function()
      if isModuleAvailable 'telescope.builtin' then
        require('telescope.builtin').lsp_definitions()
      else
        vim.lsp.buf.definition()
      end
    end)
    vim.keymap.set('n', 'gh', vim.lsp.buf.hover)
    vim.keymap.set('n', 'gi', function()
      if isModuleAvailable 'fzf-lua' then
        require('fzf-lua').lsp_references()
      else
        vim.lsp.buf.references()
      end
    end)
    vim.keymap.set({ 'n', 'x' }, 'gp', vim.lsp.buf.format)

    vim.api.nvim_create_autocmd('BufWritePre', {
      group = augroup,
      callback = function()
        if not isModuleAvailable 'gitsigns' then
          vim.lsp.buf.format()
          return
        end
        local hunks = require('gitsigns').get_hunks()
        if hunks == nil then
          vim.lsp.buf.format()
          return
        end
        for i = #hunks, 1, -1 do
          local hunk = hunks[i]
          if hunk ~= nil and hunk.type ~= 'delete' then
            local start = hunk.added.start
            local last = start + hunk.added.count
            local last_hunk_line = vim.api.nvim_buf_get_lines(0, last - 2, last - 1, true)[1]
            local range = { start = { start, 0 }, ['end'] = { last - 1, last_hunk_line:len() } }
            vim.lsp.buf.format { range = range }
          end
        end
      end,
    })
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'cpp',
      callback = function() vim.keymap.set('n', '<leader>gd', '<cmd>LspClangdSwitchSourceHeader<cr>') end,
    })
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'typescript,typescriptreact',
      callback = function()
        vim.keymap.set('n', 'go', function()
          typescript.add_missing_imports()
          typescript.remove_unused_imports()
          typescript.sort_imports()
        end)
      end,
    })
    vim.lsp.inlay_hint.enable()
  end,
}
