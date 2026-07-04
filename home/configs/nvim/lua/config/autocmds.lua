-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Aggressive Auto-Reload: Check for file changes when you stop typing or enter buffer
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI", "FocusGained", "BufEnter" }, {
    desc = "Aggressively check for file changes outside of Neovim",
    callback = function()
        if vim.o.buftype ~= "nofile" then
            vim.cmd("checktime")
        end
    end,
})

-- Safe Auto-Save: Saves only when you click out of Neovim or switch files
vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave" }, {
    desc = "Auto Save on focus lost and buffer leave",
    callback = function()
        -- Only save if the buffer has been modified, isn't read-only, and is a real file
        if vim.bo.modified and not vim.bo.readonly and vim.fn.expand("%") ~= "" and vim.bo.buftype == "" then
            vim.cmd("silent! update")
        end
    end,
})

-- Force WinSeparator visible (fixes invisible splits in Dracula and similar themes)
local function set_border_highlights()
    vim.api.nvim_set_hl(0, "WinSeparator", { link = "Keyword" })
    vim.api.nvim_set_hl(0, "SnacksWinSeparator", { link = "Keyword" })
end
set_border_highlights()
vim.api.nvim_create_autocmd("ColorScheme", { callback = set_border_highlights })
