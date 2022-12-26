return {
  'diartyz/nvim-sort-json',
  run = { 'yarn install --frozen-lockfile', ':UpdateRemotePlugins' },
  config = function()
    vim.g.sort_json = {
      orderOverride = {
        'name',
        'private',
        'version',
        'description',
        'main',
        'module',
        'type',
        'types',
        'typings',
        'files',
        'publishConfig',
        'repository',
        'license',
        'scripts',
      },
      orderUnderride = {
        'resolutions',
        'dependencies',
        'devDependencies',
        'peerDependencies',
        'source.organizeImports',
      },
    }
  end,
}
