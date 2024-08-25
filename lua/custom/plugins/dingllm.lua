return {
  'yacineMTB/dingllm.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local system_prompt =
      'You should replace the code that you are sent, only following the comments. Do not talk at all. Only output valid code. Do not provide any backticks that surround the code. Never ever output backticks like this ```. Any comment that is asking you for something should be removed after you satisfy them. Other comments should left alone. Do not output backticks'
    local helpful_prompt = 'You are a helpful assistant. What I have sent are my notes so far.'
    local dingllm = require 'dingllm'

    -- local function handle_open_router_spec_data(data_stream)
    --   local success, json = pcall(vim.json.decode, data_stream)
    --   if success then
    --     if json.choices and json.choices[1] and json.choices[1].text then
    --       local content = json.choices[1].text
    --       if content then
    --         dingllm.write_string_at_cursor(content)
    --       end
    --     end
    --   else
    --     print('non json ' .. data_stream)
    --   end
    -- end
    --
    -- local function custom_make_openai_spec_curl_args(opts, prompt)
    --   local url = opts.url
    --   local api_key = opts.api_key_name and os.getenv(opts.api_key_name)
    --   local data = {
    --     prompt = prompt,
    --     model = opts.model,
    --     temperature = 0.7,
    --     stream = true,
    --   }
    --   local args = { '-N', '-X', 'POST', '-H', 'Content-Type: application/json', '-d', vim.json.encode(data) }
    --   if api_key then
    --     table.insert(args, '-H')
    --     table.insert(args, 'Authorization: Bearer ' .. api_key)
    --   end
    --   table.insert(args, url)
    --   return args
    -- end
    --
    -- local function llama_405b_base()
    --   dingllm.invoke_llm_and_stream_into_editor({
    --     url = 'https://openrouter.ai/api/v1/chat/completions',
    --     model = 'meta-llama/llama-3.1-405b',
    --     api_key_name = 'OPEN_ROUTER_API_KEY',
    --     max_tokens = '128',
    --     replace = false,
    --   }, custom_make_openai_spec_curl_args, handle_open_router_spec_data)
    -- end

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
        model = 'gpt-4o-mini',
        api_key_name = 'OPENAI_API_KEY',
        system_prompt = system_prompt,
        replace = true,
      }, dingllm.make_openai_spec_curl_args, dingllm.handle_openai_spec_data)
    end

    local function openai_help()
      dingllm.invoke_llm_and_stream_into_editor({
        url = 'https://api.openai.com/v1/chat/completions',
        model = 'gpt-4o-mini',
        api_key_name = 'OPENAI_API_KEY',
        system_prompt = helpful_prompt,
        replace = false,
      }, dingllm.make_openai_spec_curl_args, dingllm.handle_openai_spec_data)
    end

    local function ollama_replace()
      dingllm.invoke_llm_and_stream_into_editor({
        url = 'localhost:11434/v1/chat/completions',
        model = 'llama3.1',
        api_key_name = 'ollama',
        system_prompt = system_prompt,
        replace = true,
      }, dingllm.make_openai_spec_curl_args, dingllm.handle_openai_spec_data)
    end

    local function ollama_help()
      dingllm.invoke_llm_and_stream_into_editor({
        url = 'localhost:11434/v1/chat/completions',
        model = 'llama3.1',
        api_key_name = 'ollama',
        system_prompt = helpful_prompt,
        replace = false,
      }, dingllm.make_openai_spec_curl_args, dingllm.handle_openai_spec_data)
    end

    local function right_window()
      -- Create a new buffer
      local bufnr = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_option(bufnr, 'bufhidden', 'wipe')

      -- Get the current window width
      local win_width = vim.api.nvim_win_get_width(0)

      -- Calculate dimensions for the new window
      local width = math.floor(win_width * 0.4)
      local height = vim.api.nvim_win_get_height(0)

      -- Open a new window on the right
      vim.cmd 'vsplit'
      vim.cmd('vertical resize ' .. width)
      local win = vim.api.nvim_get_current_win()
      vim.api.nvim_win_set_buf(win, bufnr)

      -- Check if we are in visual mode
      if vim.fn.mode() == 'v' or vim.fn.mode() == 'V' or vim.fn.mode() == '\22' then
        -- Get the selected text
        local start_line, start_col = unpack(vim.api.nvim_buf_get_mark(0, '<'))
        local end_line, end_col = unpack(vim.api.nvim_buf_get_mark(0, '>'))
        local lines = vim.api.nvim_buf_get_text(0, start_line - 1, start_col, end_line - 1, end_col + 1, {})

        -- Add backticks to the selected text
        local snippet = { '```' }
        vim.list_extend(snippet, lines)
        table.insert(snippet, '```')

        -- Set the content of the buffer
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, snippet)
      end
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

    vim.keymap.set({ 'n', 'v' }, '<leader>xx', right_window, { desc = 'Open Blank Chat' })
  end,
}
