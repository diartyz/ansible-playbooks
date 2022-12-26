return {
  'neovim/nvim-lspconfig',
  requires = {
    'hrsh7th/nvim-cmp',
    'jose-elias-alvarez/typescript.nvim',
    { 'williamboman/mason.nvim', config = function() require('mason').setup() end },
    {
      'williamboman/mason-lspconfig.nvim',
      config = function()
        require('mason-lspconfig').setup {
          automatic_installation = true,
        }
      end,
    },
    {
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      config = function()
        require('mason-tool-installer').setup {
          auto_update = true,
          ensure_installed = {
            'eslint_d',
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
        }
      end,
    },
  },
  config = function()
    local augroup = vim.api.nvim_create_augroup('LspFormatting', { clear = true })
    local function lsp_config(overrides)
      local on_attach = overrides and overrides.on_attach
      return vim.tbl_extend('force', overrides or {}, {
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
        on_attach = function(_, bufnr)
          if on_attach then on_attach(_, bufnr) end
          vim.api.nvim_create_autocmd('BufWritePre', {
            group = augroup,
            buffer = bufnr,
            callback = function() vim.lsp.buf.format() end,
          })
        end,
      })
    end
    require('mason-lspconfig').setup_handlers {
      function(server_name) require('lspconfig')[server_name].setup(lsp_config()) end,
      tsserver = function()
        require('typescript').setup {
          server = lsp_config {
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
          },
        }
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
    vim.keymap.set('n', '<c-j>', vim.diagnostic.goto_next)
    vim.keymap.set('n', '<c-k>', vim.diagnostic.goto_prev)
    vim.keymap.set('n', '<c-t>', require('telescope.builtin').lsp_document_symbols)
    vim.keymap.set('n', '<leader>.', vim.lsp.buf.code_action)
    vim.keymap.set('n', '<leader>gd', '<cmd>Telescope lsp_references<cr>')
    vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename)
    vim.keymap.set('n', 'gd', '<cmd>Telescope lsp_definitions<cr>')
    vim.keymap.set('n', 'gh', vim.lsp.buf.hover)
    vim.keymap.set('n', 'gi', '<cmd>Telescope lsp_implementations<cr>')
    vim.keymap.set('n', 'gp', vim.lsp.buf.format)
    vim.keymap.set('n', 'go', function()
      require('typescript').actions.removeUnused { sync = true }
      require('typescript').actions.organizeImports { sync = true }
    end)
  end,
}
