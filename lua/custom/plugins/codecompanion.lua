return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'nvim-telescope/telescope.nvim', -- Optional
    {
      'stevearc/dressing.nvim', -- Optional: Improves the default Neovim UI
      opts = {},
    },
  },
  config = function()
    require('codecompanion').setup {
      adapters = {
        llama3 = function()
          return require('codecompanion.adapters').use('ollama', {
            name = 'llama3.1', -- Ensure the model is differentiated from Ollama
            schema = {
              model = {
                default = 'llama3.1:latest',
              },
              num_ctx = {
                default = 16384,
              },
              num_predict = {
                default = -1,
              },
            },
          })
        end,
      },
      strategies = {
        inline = {
          adapter = 'llama3',
        },
        agent = {
          adapter = 'llama3',
        },
        chat = {
          adapter = 'llama3',
        },
      },
    }
  end,
}
