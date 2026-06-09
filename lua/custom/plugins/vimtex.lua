return {
  'lervag/vimtex',
  config = function()
    vim.g.vimtex_view_method = 'zathura'
    -- require('lspconfig').texlab.setup {}
    vim.lsp.enable 'texlab'
    -- vim.lsp.config('texlab', {
    --   capabilities = {
    --     general = {
    --       positionEncodings = { 'utf-16' },
    --     },
    --   },
    -- })
  end,
}
