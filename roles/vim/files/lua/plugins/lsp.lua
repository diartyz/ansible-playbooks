return {
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'hrsh7th/cmp-nvim-lsp', lazy = true },
    { 'ray-x/lsp_signature.nvim', lazy = true },
    { 'williamboman/mason.nvim', config = true },
    { 'williamboman/mason-lspconfig.nvim', opts = { automatic_installation = true } },
    {
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      opts = {
        auto_update = true,
        ensure_installed = {
          'clangd',
          'eslint-lsp',
          'graphql-language-service-cli',
          'json-lsp',
          'lua-language-server',
          'prettierd',
          'python-lsp-server',
          'rust-analyzer',
          'stylua',
          'typescript-language-server',
          'vim-language-server',
        },
      },
    },
  },
  config = function()
    local augroup = vim.api.nvim_create_augroup('LspFormatting', { clear = true })
    local function format()
      local hunks = require('gitsigns').get_hunks()
      if hunks == nil then
        vim.lsp.buf.format()
      else
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
      end
    end
    local function lsp_config(overrides)
      local on_attach = overrides and overrides.on_attach
      return vim.tbl_extend('force', overrides or {}, {
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
        on_attach = function(client, bufnr)
          if on_attach then on_attach(client, bufnr) end
          require('lsp_signature').on_attach({}, bufnr)
          vim.api.nvim_create_autocmd('BufWritePre', {
            group = augroup,
            buffer = bufnr,
            callback = format,
          })
        end,
      })
    end

    require('mason-lspconfig').setup_handlers {
      function(server_name) require('lspconfig')[server_name].setup(lsp_config()) end,

      clangd = function() require('lspconfig').clangd.setup(lsp_config(vim.g.clangd_config or {})) end,

      tsserver = function()
        require('lspconfig').tsserver.setup(lsp_config {
          init_options = {
            preferences = {
              importModuleSpecifierPreference = 'project-relative',
              jsxAttributeCompletionStyle = 'none',
            },
          },
          on_attach = function(client)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end,
        })
      end,

      lua_ls = function()
        require('lspconfig').lua_ls.setup(lsp_config {
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
      end,

      jsonls = function()
        require('lspconfig').jsonls.setup(lsp_config {
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
      end,
    }

    local typescript = require 'plugins/typescript'

    vim.keymap.set('n', '<c-j>', vim.diagnostic.goto_next)
    vim.keymap.set('n', '<c-k>', vim.diagnostic.goto_prev)
    vim.keymap.set('n', '<c-t>', function() require('telescope.builtin').lsp_document_symbols { symbol_width = 39 } end)
    vim.keymap.set('n', '<f2>', vim.lsp.buf.rename)
    vim.keymap.set('n', '<leader>.', vim.lsp.buf.code_action)
    vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename)
    vim.keymap.set('n', 'gd', function() require('telescope.builtin').lsp_definitions() end)
    vim.keymap.set('n', 'gh', vim.lsp.buf.hover)
    vim.keymap.set('n', 'gi', function() require('fzf-lua').lsp_references() end)
    vim.keymap.set({ 'n', 'v' }, 'gp', vim.lsp.buf.format)

    vim.api.nvim_create_user_command('F', format, { nargs = 0 })

    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'cpp',
      callback = function() vim.keymap.set('n', '<leader>gd', '<cmd>ClangdSwitchSourceHeader<cr>') end,
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
  end,
}
