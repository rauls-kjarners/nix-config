-- Task runner + file operations
-- overseer.nvim: define and run tasks (bin/console, composer, docker-compose)
--   replaces PhpStorm's Run Configurations for CLI tasks
-- vim-eunuch: :Rename, :Move, :Delete for the current buffer's file

return {
    {
        "stevearc/overseer.nvim",
        opts = {},
        cmd = { "OverseerRun", "OverseerToggle", "OverseerBuild", "OverseerInfo" },
        keys = {
            { "<leader>ot", "<cmd>OverseerToggle<cr>", desc = "Overseer: toggle panel" },
            { "<leader>or", "<cmd>OverseerRun<cr>", desc = "Overseer: run task" },
            { "<leader>oi", "<cmd>OverseerInfo<cr>", desc = "Overseer: task info" },
        },
    },

    -- File operations on the current buffer (rename, move, delete)
    {
        "tpope/vim-eunuch",
        cmd = { "Rename", "Move", "Delete", "Mkdir", "SudoWrite", "Chmod" },
    },
}
