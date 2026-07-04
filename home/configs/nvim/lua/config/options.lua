-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Python LSP selection (pyright + ruff via lang.python extra)
vim.g.lazyvim_python_lsp = "pyright"

-- Persistent undo (required for undotree cross-session history)
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"

vim.opt.wrap = false

-- Disable whole line highlight (reduces noise and fixes color conflict with ColorColumn)
vim.opt.cursorline = false

-- Hide the tab/buffer line at the top
vim.opt.showtabline = 0

-- Disable swap files (prevents annoying "Swap file already exists" prompts)
vim.opt.swapfile = false
