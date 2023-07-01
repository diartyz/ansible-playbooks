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
      'quangnguyen30192/cmp-nvim-ultisnips',
      dependencies = 'SirVer/ultisnips',
      init = function() vim.g.UltiSnipsExpandTrigger = '<c-;>' end,
    },
    {
      'tzachar/cmp-tabnine',
      build = './install.sh',
    },
  },
  config = function()
    local cmp = require 'cmp'
    local types = require 'cmp.types'

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

          return require('lspkind').cmp_format {
            mode = 'symbol_text',
          }(entry, vim_item)
        end,
      },

      mapping = {
        ['<c-space>'] = cmp.mapping.complete(),
        ['<c-l>'] = cmp.mapping.abort(),
        ['<tab>'] = function(fallback)
          if cmp.get_active_entry() then
            cmp.confirm {
              behavior = cmp.ConfirmBehavior.Replace,
              select = false,
            }
          else
            fallback()
          end
        end,
        ['<c-n>'] = function()
          if cmp.visible() then
            cmp.select_next_item { behavior = types.cmp.SelectBehavior.Insert }
          else
            cmp.complete()
          end
        end,
        ['<c-p>'] = function()
          if cmp.visible() then
            cmp.select_prev_item { behavior = types.cmp.SelectBehavior.Insert }
          else
            cmp.complete()
          end
        end,
      },

      snippet = {
        expand = function(args) vim.fn['UltiSnips#Anon'](args.body) end,
      },

      sources = cmp.config.sources({
        { name = 'nvim_lua' },
      }, {
        { name = 'cmp_tabnine' },
        { name = 'nvim_lsp' },
        { name = 'ultisnips' },
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
