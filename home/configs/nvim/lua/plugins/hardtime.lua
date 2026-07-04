return {
    "m4xshen/hardtime.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
        restricted_keys = {
            ["j"] = { "n", "x" },
            ["k"] = { "n", "x" },
            ["l"] = { "n", "x" },
            [";"] = { "n", "x" },
            ["h"] = false,
            ["-"] = { "n", "x" },
        },
    },
}
