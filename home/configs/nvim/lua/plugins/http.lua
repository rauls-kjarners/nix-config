-- HTTP client for .http files (JetBrains HTTP Client compatible syntax)
-- kulala.nvim: modern, actively maintained, reads .http / .rest files

return {
    {
        "mistweaverco/kulala.nvim",
        ft = { "http", "rest" },
        opts = {},
        keys = {
            {
                "<leader>kr",
                function()
                    require("kulala").run()
                end,
                ft = "http",
                desc = "HTTP: run request",
            },
            {
                "<leader>ka",
                function()
                    require("kulala").run_all()
                end,
                ft = "http",
                desc = "HTTP: run all",
            },
            {
                "<leader>kn",
                function()
                    require("kulala").jump_next()
                end,
                ft = "http",
                desc = "HTTP: next request",
            },
            {
                "<leader>kp",
                function()
                    require("kulala").jump_prev()
                end,
                ft = "http",
                desc = "HTTP: prev request",
            },
            {
                "<leader>ki",
                function()
                    require("kulala").inspect()
                end,
                ft = "http",
                desc = "HTTP: inspect",
            },
        },
    },
}
