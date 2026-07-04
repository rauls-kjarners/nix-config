return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                -- Disable marksman (installed by LazyVim's default markdown extra)
                marksman = false,
            },
        },
    },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "markdown" },
        opts = {
            enabled = false, -- Disabled by default, toggle manually
        },
    },
}
