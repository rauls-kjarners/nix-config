return {

    -- Snacks picker override (snacks is the default LazyVim picker; needs the same remaps)
    -- Default snacks: C-k=list_up, j=list_down in list, C-n/C-p still work and are kept.
    {
        "folke/snacks.nvim",
        optional = true,
        opts = {
            picker = {
                win = {
                    input = {
                        keys = {
                            -- k=down, l=up to match jkl; movement scheme; disable j (= left in scheme)
                            ["<C-j>"] = false,
                            ["<C-k>"] = { "list_down", mode = { "i", "n" } },
                            ["<C-l>"] = { "list_up", mode = { "i", "n" } },
                            -- Add normal mode equivalents for jkl;
                            ["j"] = false,
                            ["k"] = { "list_down", mode = "n" },
                            ["l"] = { "list_up", mode = "n" },
                        },
                    },
                    list = {
                        keys = {
                            -- Disable j (list_down by default, but j=left in global scheme)
                            ["j"] = false,
                            ["k"] = "list_down",
                            ["l"] = "list_up",
                        },
                    },
                },
                sources = {
                    explorer = {
                        win = {
                            input = {
                                keys = {
                                    ["l"] = { "list_up", mode = "n" },
                                    ["k"] = { "list_down", mode = "n" },
                                    ["j"] = { "explorer_close", mode = "n" },
                                    [";"] = { "confirm", mode = "n" },
                                    ["h"] = false,
                                },
                            },
                            list = {
                                keys = {
                                    ["l"] = "list_up",
                                    ["k"] = "list_down",
                                    ["j"] = "explorer_close",
                                    [";"] = "confirm",
                                    ["h"] = false,
                                },
                            },
                        },
                    },
                },
            },
        },
    },

    -- Neo-tree override (jkl; navigation scheme: j=left/close, k=down, l=up/none, ;=right/open)
    {
        "nvim-neo-tree/neo-tree.nvim",
        opts = {
            window = {
                mappings = {
                    ["l"] = "none", -- Fall back to global k (Move Up)
                    ["k"] = "none", -- Fall back to global j (Move Down)
                    ["j"] = "close_node", -- Explicit Neo-tree command for Left
                    [";"] = "open", -- Explicit Neo-tree command for Right
                    ["h"] = "none", -- Clear LazyVim's default close_node mapping on h
                },
            },
        },
    },
}
