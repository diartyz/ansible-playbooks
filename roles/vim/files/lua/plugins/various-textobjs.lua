return {
  'chrisgrieser/nvim-various-textobjs',
  keys = {
    {
      'af',
      function() require('various-textobjs').greedyOuterIndentation 'outer' end,
      mode = { 'o', 'x' },
      desc = '@function.outer',
    },
    {
      'if',
      function() require('various-textobjs').greedyOuterIndentation 'inner' end,
      mode = { 'o', 'x' },
      desc = '@function.inner',
    },
  },
  config = true,
  -- opts = {
  --   keymaps = {
  --     useDefaults = true,
  --   },
  -- },
}
