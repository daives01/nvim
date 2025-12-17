return {
  'NickvanDyke/opencode.nvim',
  dependencies = {
    { 'folke/snacks.nvim', opts = { input = {}, picker = {}, terminal = {} } },
  },
  config = function()
    local opts = vim.g.opencode_opts or {}
    opts.provider = opts.provider or { enabled = 'snacks' }
    vim.g.opencode_opts = opts

    vim.o.autoread = true

    local opencode = require 'opencode'

    vim.keymap.set({ 'n', 'x' }, '<leader>oa', function()
      opencode.ask('@this: ', { submit = true })
    end, { desc = 'opencode ask here' })

    vim.keymap.set({ 'n', 'x' }, '<leader>os', opencode.select, { desc = 'opencode select action' })

    vim.keymap.set({ 'n', 'x' }, '<leader>op', function()
      opencode.prompt '@this'
    end, { desc = 'opencode prompt @this' })

    vim.keymap.set('n', '<leader>oo', opencode.toggle, { desc = 'opencode toggle' })
  end,
}

