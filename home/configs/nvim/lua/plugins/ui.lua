return {
    { "akinsho/bufferline.nvim", enabled = false },

    -- Disable LSP inlay hints globally and disable default virtual text
    {
        "neovim/nvim-lspconfig",
        opts = {
            inlay_hints = { enabled = false },
            diagnostics = {
                virtual_text = false,
            },
        },
    },

    -- Beautiful multiline box for diagnostics
    {
        "rachartier/tiny-inline-diagnostic.nvim",
        event = "VeryLazy",
        config = function()
            require("tiny-inline-diagnostic").setup({
                signs = {
                    arrow = " <- ", -- reduced spacing for a tighter gap
                },
                options = {
                    -- This makes the arrow brightly colored to match the error/warning color
                    -- instead of the default dim color
                    set_arrow_to_diag_color = true,
                },
            })
        end,
    },
}
