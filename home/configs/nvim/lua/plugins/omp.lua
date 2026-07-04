return {
    {
        "rauls-kjarners/omp.nvim",
        lazy = false,
        keys = {
            {
                "<leader>ao",
                function()
                    Snacks.terminal.toggle("omp", {
                        win = {
                            position = "right",
                            width = 0.4,
                        },
                    })
                end,
                desc = "Toggle Oh My Pi",
            },
        },
        config = function()
            require("omp").setup()
        end,
    },
}
