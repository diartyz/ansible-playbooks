return {
  'hrsh7th/nvim-cmp',
  requires = {
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-nvim-lua',
    'hrsh7th/cmp-path',
    'onsails/lspkind.nvim',
    { 'tzachar/cmp-tabnine', run = './install.sh' },
    {
      'quangnguyen30192/cmp-nvim-ultisnips',
      requires = 'SirVer/ultisnips',
      config = function() vim.g.UltiSnipsExpandTrigger = '<c-;>' end,
    },
  },
  config = function()
    local cmp = require 'cmp'
    cmp.setup {
      formatting = {
        format = function(entry, vim_item)
          if entry.source.name == 'cmp_tabnine' and entry.completion_item.data ~= nil then
            vim_item.kind = string.format('%s %s', '', 'Tabnine')
            return vim_item
          end
          return require('lspkind').cmp_format { mode = 'symbol_text' }(entry, vim_item)
        end,
      },
      mapping = cmp.mapping.preset.insert {
        ['<c-space>'] = cmp.mapping.complete(),
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
