return {
  'karb94/neoscroll.nvim',
  lazy = false,
  config = function()
    require('neoscroll').setup {
      mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>' },
      duration_multiplier = 0.1,
    }
  end,
}
