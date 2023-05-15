return {
  'hrsh7th/nvim-cmp',
  requires = {
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-nvim-lua',
    'hrsh7th/cmp-path',
    'onsails/lspkind.nvim',
    {
      'quangnguyen30192/cmp-nvim-ultisnips',
      requires = 'SirVer/ultisnips',
      config = function() vim.g.UltiSnipsExpandTrigger = '<c-;>' end,
    },
    {
      'tzachar/cmp-tabnine',
      run = './install.sh',
    },
    {
      'zbirenbaum/copilot.lua',
      config = function()
        require('copilot').setup {
          suggestion = { enabled = false },
          panel = { enabled = false },
        }
      end,
    },
    {
      'zbirenbaum/copilot-cmp',
      config = function() require('copilot_cmp').setup() end,
    },
  },
  config = function()
    local cmp = require 'cmp'
    cmp.setup {
      formatting = {
        format = function(entry, vim_item)
          if entry.source.name == 'cmp_tabnine' then
            vim_item.kind = ' Tabnine'
            vim_item.menu = ''
            local detail = (entry.completion_item.labelDetails or {}).detail
            if detail and detail:find '.*%%.*' then
              vim_item.kind = string.format('%s%s %s', vim_item.kind, ':', detail)
            end
            if (entry.completion_item.data or {}).multiline then vim_item.kind = vim_item.kind .. '*' end
            return vim_item
          end
          return require('lspkind').cmp_format {
            mode = 'symbol_text',
            symbol_map = { Copilot = '' },
          }(entry, vim_item)
        end,
      },
      mapping = cmp.mapping.preset.insert {
        ['<c-space>'] = cmp.mapping.complete(),
        ['c-e'] = cmp.mapping.abort(),
        ['<tab>'] = function(fallback)
          if cmp.get_active_entry() then
            cmp.confirm { select = false }
          else
            fallback()
          end
        end,
      },
      snippet = {
        expand = function(args) vim.fn['UltiSnips#Anon'](args.body) end,
      },
      sources = cmp.config.sources({
        { name = 'nvim_lua' },
      }, {

        { name = 'copilot' },
        { name = 'cmp_tabnine' },
        { name = 'nvim_lsp' },
        { name = 'ultisnips' },
      }, {
        { name = 'buffer' },
      }),
    }
    cmp.setup.cmdline('/', {
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
