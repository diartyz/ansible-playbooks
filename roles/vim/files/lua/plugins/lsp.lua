return {
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'williamboman/mason.nvim', opts = { ui = { keymaps = { toggle_help = '?' } } } },
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
    -- lsp config
    local function disable_format(client)
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end
    local is_module_available = require('core/utils').is_module_available
    -- local function lsp_config(overrides)
    --   local on_attach = overrides and overrides.on_attach
    --   return vim.tbl_extend('force', overrides or {}, {
    --     capabilities = isModuleAvailable 'cmp_nvim_lsp' and require('cmp_nvim_lsp').default_capabilities() or nil,
    --     on_attach = function(client, bufnr)
    --       if on_attach then on_attach(client, bufnr) end
    --     end,
    --   })
    -- end
    -- local function merge_config(name, config)
    --   vim.lsp.config(name, config)
    --   -- vim.lsp.config(name, lsp_config(vim.tbl_extend('force', vim.lsp.config[name], config)))
    -- end

    -- vim.lsp.config('*', lsp_config())
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
          format = {
            enable = false,
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
    vim.lsp.config('pylsp', {
      on_attach = disable_format,
    })
    vim.lsp.config('ts_ls', {
      init_options = {
        preferences = {
          importModuleSpecifierPreference = 'project-relative',
          jsxAttributeCompletionStyle = 'none',
        },
      },
      on_attach = disable_format,
    })

    -- mapping
    local pos_equal = function(p1, p2)
      local r1, c1 = (table.unpack or unpack)(p1)
      local r2, c2 = (table.unpack or unpack)(p2)
      return r1 == r2 and c1 == c2
    end
    vim.keymap.set('n', '<c-j>', function()
      local pos = vim.api.nvim_win_get_cursor(0)
      vim.diagnostic.jump { count = 1, severity = vim.diagnostic.severity.ERROR }
      local pos2 = vim.api.nvim_win_get_cursor(0)
      if pos_equal(pos, pos2) then vim.diagnostic.jump { count = 1 } end
    end, { desc = 'Next Diagnostic' })
    vim.keymap.set('n', '<c-k>', function()
      local pos = vim.api.nvim_win_get_cursor(0)
      vim.diagnostic.jump { count = -1, severity = vim.diagnostic.severity.ERROR }
      local pos2 = vim.api.nvim_win_get_cursor(0)
      if pos_equal(pos, pos2) then vim.diagnostic.jump { count = -1 } end
    end, { desc = 'Prev Diagnostic' })
    vim.keymap.set('n', '<c-t>', function()
      if is_module_available 'telescope.builtin' then
        require('telescope.builtin').lsp_document_symbols { symbol_width = 39 }
      else
        vim.lsp.buf.document_symbol()
      end
    end, { desc = 'LSP Document Symbols' })
    vim.keymap.set('n', '<f2>', vim.lsp.buf.rename, { desc = 'LSP Rename' })
    vim.keymap.set('n', '<leader>.', vim.lsp.buf.code_action, { desc = 'LSP Code Action' })
    vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, { desc = 'LSP Rename' })
    vim.keymap.set('n', 'gd', function()
      if is_module_available 'telescope.builtin' then
        require('telescope.builtin').lsp_definitions()
      else
        vim.lsp.buf.definition()
      end
    end, { desc = 'LSP Definition' })
    vim.keymap.set('n', 'gh', vim.lsp.buf.hover, { desc = 'LSP Hover' })
    vim.keymap.set('n', 'gi', function()
      if is_module_available 'fzf-lua' then
        require('fzf-lua').lsp_references()
      else
        vim.lsp.buf.references()
      end
    end, { desc = 'LSP References' })
    vim.keymap.set({ 'n', 'x' }, 'gq', vim.lsp.buf.format, { desc = 'LSP Format' })
    vim.keymap.set(
      'n',
      'yoh',
      function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end,
      { desc = 'Toggle inlay hint' }
    )

    -- autocmd
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = vim.api.nvim_create_augroup('LspFormatting', { clear = true }),
      callback = function()
        if not is_module_available 'gitsigns' then
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
      callback = function() vim.keymap.set('n', 'go', '<cmd>LspClangdSwitchSourceHeader<cr>') end,
    })
    local typescript = require 'plugins/typescript'
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

    -- virtual text
    vim.diagnostic.config { virtual_text = true }
    vim.lsp.inlay_hint.enable()
  end,
}
