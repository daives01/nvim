# Agent Guidelines for kickstart-modular.nvim

## Build/Lint Commands
- **Lint**: `stylua --check .`
- **Format**: `stylua .`

## Code Style Guidelines
- **Formatting**: 2-space indentation, Unix line endings, 160 column width
- **Quotes**: Auto-prefer single quotes
- **Function calls**: No parentheses for function calls
- **Naming**: Use descriptive names, kebab-case for plugin names
- **Imports**: Use `require 'module'` for Lua modules
- **Options**: Use `vim.opt.option = value` for Neovim options
- **Comments**: Use `--` for single-line comments, descriptive and helpful
- **Error handling**: Use Neovim's built-in error handling patterns
- **Types**: No explicit typing (dynamic Lua), rely on clear naming

## Project Structure
- `lua/kickstart/plugins/`: Plugin configurations
- `lua/custom/plugins/`: Custom plugin additions
- `init.lua`: Main entry point
- Follow modular structure, one plugin per file
