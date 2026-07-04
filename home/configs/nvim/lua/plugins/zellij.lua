return {
    {
        "swaits/zellij-nav.nvim",
        lazy = true,
        event = "VeryLazy",
        keys = {
            { "<A-j>", "<cmd>ZellijNavigateLeft<cr>", desc = "Navigate left (Zellij/Neovim)", silent = true },
            { "<A-k>", "<cmd>ZellijNavigateDown<cr>", desc = "Navigate down (Zellij/Neovim)", silent = true },
            { "<A-l>", "<cmd>ZellijNavigateUp<cr>", desc = "Navigate up (Zellij/Neovim)", silent = true },
            { "<A-;>", "<cmd>ZellijNavigateRight<cr>", desc = "Navigate right (Zellij/Neovim)", silent = true },
        },
        opts = {},
    },
}
