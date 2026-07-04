-- Refactoring tools
-- refactoring.nvim: extract function/variable, inline variable
-- treesj: split/join blocks (one-liner ↔ multi-line)
-- substitute.nvim: `s` operator — replace motion target with yanked text
-- iswap.nvim: swap function arguments and array elements
--
-- NOTE: LazyVim maps `s` to flash.nvim by default.
-- We remove flash's `s`/`S` keys here and give them to substitute.nvim.
-- Flash is still available via `<leader>s` patterns and `f`/`t` motions.

return {
    -- Remove flash.nvim's s/S keymaps to free them for substitute.nvim
    {
        "folke/flash.nvim",
        optional = true,
        keys = {
            { "s", mode = { "n", "x", "o" }, false },
            { "S", mode = { "n", "x", "o" }, false },
        },
    },

    -- Extract function, extract variable, inline variable (treesitter-based)
    {
        "ThePrimeagen/refactoring.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
        opts = {},
        keys = {
            {
                "<leader>re",
                function()
                    require("refactoring").refactor("Extract Function")
                end,
                mode = "x",
                desc = "Refactor: extract function",
            },
            {
                "<leader>rf",
                function()
                    require("refactoring").refactor("Extract Function To File")
                end,
                mode = "x",
                desc = "Refactor: extract to file",
            },
            {
                "<leader>rv",
                function()
                    require("refactoring").refactor("Extract Variable")
                end,
                mode = "x",
                desc = "Refactor: extract variable",
            },
            {
                "<leader>ri",
                function()
                    require("refactoring").refactor("Inline Variable")
                end,
                mode = { "n", "x" },
                desc = "Refactor: inline variable",
            },
        },
    },

    -- Split/join blocks: one-liner ↔ multi-line (great for arrays, arguments)
    {
        "Wansmer/treesj",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        opts = { use_default_keymaps = false },
        keys = {
            { "<leader>rj", "<cmd>TSJToggle<cr>", desc = "Refactor: split/join block" },
        },
    },

    -- Substitute operator: `s` + motion replaces target with last yanked text
    {
        "gbprod/substitute.nvim",
        opts = {},
        keys = {
            {
                "s",
                function()
                    require("substitute").operator()
                end,
                desc = "Substitute operator",
            },
            {
                "ss",
                function()
                    require("substitute").line()
                end,
                desc = "Substitute line",
            },
            {
                "S",
                function()
                    require("substitute").eol()
                end,
                desc = "Substitute to EOL",
            },
            {
                "s",
                function()
                    require("substitute").visual()
                end,
                mode = "x",
                desc = "Substitute visual",
            },
        },
    },

    -- Swap function arguments / array elements interactively
    {
        "mizlan/iswap.nvim",
        opts = {},
        keys = {
            { "<leader>rS", "<cmd>ISwap<cr>", desc = "Refactor: swap arguments (pick)" },
            { "<leader>rs", "<cmd>ISwapWith<cr>", desc = "Refactor: swap with next" },
        },
    },
}
