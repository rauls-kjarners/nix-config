return {
    {
        "mfussenegger/nvim-lint",
        opts = {
            linters = {
                ["markdownlint-cli2"] = {
                    args = { "-" },
                    cwd = vim.fn.expand("~"),
                },
            },
        },
    },
}
