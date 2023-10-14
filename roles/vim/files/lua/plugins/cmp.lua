return {
  'hrsh7th/nvim-cmp',
  dependencies = {
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-nvim-lua',
    'hrsh7th/cmp-path',
    'onsails/lspkind.nvim',
    {
      'L3MON4D3/LuaSnip',
      version = 'v2.*',
      build = 'make install_jsregexp',
      dependencies = 'saadparwaiz1/cmp_luasnip',
      config = function()
        local luasnip = require 'luasnip'
        vim.keymap.set({ 'i', 's' }, '<c-j>', function() luasnip.jump(1) end)
        vim.keymap.set({ 'i', 's' }, '<c-k>', function() luasnip.jump(-1) end)
      end,
    },
    {
      'tzachar/cmp-tabnine',
      build = './install.sh',
    },
  },
  event = 'InsertEnter',
  config = function()
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'

    cmp.setup {
      formatting = {
        format = function(entry, vim_item)
          if entry.source.name == 'cmp_tabnine' then
            vim_item.kind = ' Tabnine'
            vim_item.menu = ''
            if (entry.completion_item.data or {}).multiline then vim_item.kind = vim_item.kind .. '*' end
            local detail = (entry.completion_item.labelDetails or {}).detail
            if detail and detail:find '.*%%.*' then
              vim_item.kind = string.format('%s%s %s', vim_item.kind, ':', detail)
            end
            return vim_item
          end
          return require('lspkind').cmp_format { mode = 'symbol_text' }(entry, vim_item)
        end,
      },

      mapping = {
        ['<c-space>'] = cmp.mapping.complete(),
        ['<c-l>'] = cmp.mapping.abort(),
        ['<tab>'] = function(fallback)
          if cmp.visible() then
            cmp.confirm {
              behavior = cmp.ConfirmBehavior.Replace,
              select = true,
            }
          elseif luasnip.jumpable() then
            luasnip.jump(1)
          else
            fallback()
          end
        end,
        ['<c-n>'] = function()
          if cmp.visible() then
            cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
          else
            cmp.complete()
          end
        end,
        ['<c-p>'] = function()
          if cmp.visible() then
            cmp.select_prev_item { behavior = cmp.SelectBehavior.Select }
          else
            cmp.complete()
          end
        end,
      },

      snippet = {
        expand = function(args) require('luasnip').lsp_expand(args.body) end,
      },

      sources = cmp.config.sources({
        { name = 'nvim_lua' },
      }, {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'cmp_tabnine' },
      }, {
        { name = 'buffer' },
      }),
    }

    cmp.setup.cmdline({ '/', '?' }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' },
      },
    })

    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = 'path' },
      }, {
        { name = 'cmdline' },
      }),
    })
  end,
}
