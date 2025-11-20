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
      dependencies = { 'rafamadriz/friendly-snippets', 'saadparwaiz1/cmp_luasnip' },
      config = function()
        require('luasnip.loaders.from_vscode').lazy_load()
        local luasnip = require 'luasnip'
        vim.keymap.set({ 'i', 's' }, '<c-j>', function() luasnip.jump(1) end, { desc = 'snip jump next' })
        vim.keymap.set({ 'i', 's' }, '<c-k>', function() luasnip.jump(-1) end, { desc = 'snip jump prev' })
      end,
    },
    {
      'folke/lazydev.nvim',
      ft = 'lua',
      opts = { library = { { path = '${3rd}/luv/library', words = { 'vim%.uv' } } } },
    },
    {
      'tzachar/cmp-tabnine',
      build = vim.fn.has 'win64' and 'powershell ./install.ps1' or './install.sh',
      enabled = not vim.g.disable_ai,
    },
  },
  event = { 'CmdlineEnter', 'InsertEnter' },
  config = function()
    local cmp = require 'cmp'
    local feedkeys = require 'cmp.utils.feedkeys'
    local keymap = require 'cmp.utils.keymap'
    local keymap_cinkeys = function(expr)
      return string.format(keymap.t '<Cmd>set cinkeys=%s<CR>', expr and vim.fn.escape(expr, '| \t\\') or '')
    end
    local mapping_next = function()
      if cmp.visible() then
        cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
      else
        cmp.complete()
      end
    end
    local mapping_prev = function()
      if cmp.visible() then
        cmp.select_prev_item { behavior = cmp.SelectBehavior.Select }
      else
        cmp.complete()
      end
    end
    local mapping_toggle = function()
      if cmp.visible() then
        cmp.abort()
      else
        cmp.complete()
      end
    end
    local mapping_cmdline = {
      ['<tab>'] = { c = cmp.mapping.confirm { select = false } },
      ['<c-n>'] = { c = mapping_next },
      ['<c-p>'] = { c = mapping_prev },
      ['<c-]>'] = { c = mapping_toggle },
    }

    cmp.setup {
      completion = { completeopt = 'menu,menuone,noinsert' },
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
        ['<c-]>'] = mapping_toggle,
        ['<tab>'] = function(fallback)
          if cmp.visible() then
            feedkeys.call(keymap_cinkeys(), 'n')
            cmp.confirm {
              behavior = cmp.ConfirmBehavior.Replace,
              select = false,
            }
            feedkeys.call(keymap_cinkeys(vim.bo.cinkeys), 'n')
          elseif require('luasnip').jumpable() then
            require('luasnip').jump(1)
          else
            fallback()
          end
        end,
        ['<c-n>'] = mapping_next,
        ['<c-p>'] = mapping_prev,
      },
      snippet = {
        expand = function(args) require('luasnip').lsp_expand(args.body) end,
      },
      sources = cmp.config.sources(
        {
          { name = 'lazydev' },
          { name = 'nvim_lua' },
        },
        vim.g.disable_ai and {
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
          }
          or {
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
            { name = 'cmp_tabnine' },
          },
        {
          { name = 'buffer' },
        }
      ),
    }

    cmp.setup.cmdline({ '/', '?' }, {
      completion = { completeopt = 'menu,menuone,noinsert' },
      mapping = mapping_cmdline,
      sources = {
        { name = 'buffer' },
      },
    })

    cmp.setup.cmdline(':', {
      completion = { completeopt = 'menu,menuone,noinsert' },
      mapping = mapping_cmdline,
      sources = cmp.config.sources({
        { name = 'path' },
      }, {
        { name = 'cmdline' },
      }),
    })
  end,
}
