-- claudecode.nvim: IDE integration for the Claude Code CLI
-- Implements the same WebSocket protocol as the VS Code / JetBrains extensions.
-- Send selection/buffer as context, review proposed edits as in-buffer diffs.
--
-- Two usage paths:
--   Built-in:      <leader>ac spawns claude in an nvim terminal, auto-connected
--   Separate pane: run `claude --ide` in any tmux/zellij/ghostty pane;
--                  discovers nvim via lockfile at ~/.claude/ide/[port].lock

return {
    {
        "coder/claudecode.nvim",
        dependencies = { "folke/snacks.nvim" },
        event = "VeryLazy", -- start WebSocket server at startup so external
        -- `claude --ide` / `/ide` in a separate pane can attach
        config = true,
        keys = {
            { "<leader>a", nil, desc = "AI/Claude Code" },
            { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
            { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
            { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
            { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
            { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
            { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
            { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
            {
                "<leader>as",
                "<cmd>ClaudeCodeTreeAdd<cr>",
                desc = "Add file",
                ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
            },
            { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
            { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
        },
    },
}
