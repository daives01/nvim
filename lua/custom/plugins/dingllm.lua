return {
  'yacineMTB/dingllm.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local system_prompt =
      'You should replace the code that you are sent, only following the comments. Do not talk at all. Only output valid code. Do not provide any backticks that surround the code. Never ever output backticks like this ```. Any comment that is asking you for something should be removed after you satisfy them. Other comments should left alone. Do not output backticks'
    local helpful_prompt = 'You are a helpful assistant. What I have sent are my notes so far.'
    local dingllm = require 'dingllm'

    local function groq_replace()
      dingllm.invoke_llm_and_stream_into_editor({
        url = 'https://api.groq.com/openai/v1/chat/completions',
        model = 'llama-3.1-70b-versatile',
        api_key_name = 'GROQ_API_KEY',
        system_prompt = system_prompt,
        replace = true,
      }, dingllm.make_openai_spec_curl_args, dingllm.handle_openai_spec_data)
    end

    local function groq_help()
      dingllm.invoke_llm_and_stream_into_editor({
        url = 'https://api.groq.com/openai/v1/chat/completions',
        model = 'llama-3.1-70b-versatile',
        api_key_name = 'GROQ_API_KEY',
        system_prompt = helpful_prompt,
        replace = false,
      }, dingllm.make_openai_spec_curl_args, dingllm.handle_openai_spec_data)
    end

    local function openai_replace()
      dingllm.invoke_llm_and_stream_into_editor({
        url = 'https://api.openai.com/v1/chat/completions',
        model = 'gpt-4o',
        api_key_name = 'OPENAI_API_KEY',
        system_prompt = system_prompt,
        replace = true,
      }, dingllm.make_openai_spec_curl_args, dingllm.handle_openai_spec_data)
    end

    local function openai_help()
      dingllm.invoke_llm_and_stream_into_editor({
        url = 'https://api.openai.com/v1/chat/completions',
        model = 'gpt-4o',
        api_key_name = 'OPENAI_API_KEY',
        system_prompt = helpful_prompt,
        replace = false,
      }, dingllm.make_openai_spec_curl_args, dingllm.handle_openai_spec_data)
    end

    local function ollama_replace()
      dingllm.invoke_llm_and_stream_into_editor({
        url = 'localhost:11434/v1/chat/completions',
        model = 'llama3.1',
        api_key_name = 'deepseek-coder-v2:latest',
        system_prompt = system_prompt,
        replace = true,
      }, dingllm.make_openai_spec_curl_args, dingllm.handle_openai_spec_data)
    end

    local function ollama_help()
      dingllm.invoke_llm_and_stream_into_editor({
        url = 'localhost:11434/v1/chat/completions',
        model = 'llama3.1:latest',
        api_key_name = 'deepseek-coder-v2:latest',
        system_prompt = helpful_prompt,
        replace = false,
      }, dingllm.make_openai_spec_curl_args, dingllm.handle_openai_spec_data)
    end
    local function ask_window()
      local bufnr = vim.api.nvim_create_buf(false, true)
      -- vim.api.nvim_buf_set_name(bufnr, 'ask.md')
      vim.api.nvim_buf_set_option(bufnr, 'bufhidden', 'wipe')
      vim.api.nvim_buf_set_option(bufnr, 'filetype', 'md')

      -- Get the current window width
      local win_width = vim.api.nvim_win_get_width(0)

      -- Calculate dimensions for the new window
      local width = math.floor(win_width * 0.4)

      local prompt = ''
      local filetype = '```' .. vim.bo.filetype
      local visual_lines = dingllm.get_visual_selection()
      if visual_lines then
        prompt = filetype .. '\n' .. table.concat(visual_lines, '\n') .. '\n```'

        local prompt_lines = vim.split(prompt, '\n') -- Split the prompt into a list of strings
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, prompt_lines)
      end

      -- Open a new window on the right
      vim.cmd 'vsplit'
      vim.cmd('vertical resize ' .. width)
      local win = vim.api.nvim_get_current_win()
      vim.api.nvim_win_set_buf(win, bufnr)

      -- Set the cursor to the bottom of the buffer
      local line_count = vim.api.nvim_buf_line_count(bufnr)
      vim.api.nvim_win_set_cursor(win, { line_count, 0 })
    end

    -- local function anthropic_help()
    --   dingllm.invoke_llm_and_stream_into_editor({
    --     url = 'https://api.anthropic.com/v1/messages',
    --     model = 'claude-3-5-sonnet-20240620',
    --     api_key_name = 'ANTHROPIC_API_KEY',
    --     system_prompt = helpful_prompt,
    --     replace = false,
    --   }, dingllm.make_anthropic_spec_curl_args, dingllm.handle_anthropic_spec_data)
    -- end
    --
    -- local function anthropic_replace()
    --   dingllm.invoke_llm_and_stream_into_editor({
    --     url = 'https://api.anthropic.com/v1/messages',
    --     model = 'claude-3-5-sonnet-20240620',
    --     api_key_name = 'ANTHROPIC_API_KEY',
    --     system_prompt = system_prompt,
    --     replace = true,
    --   }, dingllm.make_anthropic_spec_curl_args, dingllm.handle_anthropic_spec_data)
    -- end

    vim.keymap.set({ 'n', 'v' }, '<leader>xg', groq_replace, { desc = 'Replace (Groq)' })
    vim.keymap.set({ 'n', 'v' }, '<leader>xG', groq_help, { desc = 'Help (Groq)' })
    vim.keymap.set({ 'n', 'v' }, '<leader>xo', openai_replace, { desc = 'Replace (OpenAI)' })
    vim.keymap.set({ 'n', 'v' }, '<leader>xO', openai_help, { desc = 'Help (OpenAI)' })
    vim.keymap.set({ 'n', 'v' }, '<leader>xL', ollama_help, { desc = 'Help (Ollama)' })
    vim.keymap.set({ 'n', 'v' }, '<leader>xl', ollama_replace, { desc = 'Replace (Ollama)' })
    -- vim.keymap.set({ 'n', 'v' }, '<leader>I', anthropic_help, { desc = 'llm anthropic_help' })
    -- vim.keymap.set({ 'n', 'v' }, '<leader>i', anthropic_replace, { desc = 'llm anthropic' })
    -- vim.keymap.set({ 'n', 'v' }, '<leader>o', llama_405b_base, { desc = 'llama base' })

    vim.keymap.set({ 'n', 'v' }, '<leader>xx', ask_window, { desc = 'Open Blank Chat' })
  end,
}
