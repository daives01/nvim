return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
    'markemmons/neotest-deno',
  },
  config = function()
    require('neotest').setup {
      adapters = {
        require 'neotest-deno',
        -- Add other adapters here if needed
      },
    }
  end,
}
