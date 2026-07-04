-- Project-wide search and replace
-- ssr.nvim: structural search/replace (PhpStorm structural search equivalent)

return {

    -- Structural search/replace (treesitter-aware, language-level patterns)
    {
        "cshuaimin/ssr.nvim",
        keys = {
            {
                "<leader>rT",
                function()
                    require("ssr").open()
                end,
                mode = { "n", "x" },
                desc = "Refactor: structural search & replace",
            },
        },
    },
}
