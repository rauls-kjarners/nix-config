-- Database tooling (replaces PhpStorm's DB tool window)
-- vim-dadbod: DB connection engine
-- vim-dadbod-ui: visual schema browser + query runner
-- vim-dadbod-completion: table/column name completion in SQL buffers

return {
    {
        "tpope/vim-dadbod",
        cmd = "DB",
        lazy = true,
    },

    {
        "kristijanhusak/vim-dadbod-ui",
        dependencies = { "tpope/vim-dadbod" },
        cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
        keys = {
            { "<leader>Du", "<cmd>DBUIToggle<cr>", desc = "DB: toggle UI" },
            { "<leader>Da", "<cmd>DBUIAddConnection<cr>", desc = "DB: add connection" },
        },
        init = function()
            vim.g.db_ui_use_nerd_fonts = 1
            vim.g.db_ui_show_database_icon = 1

            -- Re-assert window navigation to prevent DBUI from hijacking <C-j> and <C-k>
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "dbui" },
                callback = function()
                    vim.keymap.set("n", "<C-j>", "<C-w>h", { desc = "Go to Left Window", remap = true, buffer = true })
                    vim.keymap.set("n", "<C-k>", "<C-w>j", { desc = "Go to Lower Window", remap = true, buffer = true })
                    vim.keymap.set("n", "<C-l>", "<C-w>k", { desc = "Go to Upper Window", remap = true, buffer = true })
                    vim.keymap.set("n", "<C-;>", "<C-w>l", { desc = "Go to Right Window", remap = true, buffer = true })
                end,
            })
        end,
    },

    {
        "kristijanhusak/vim-dadbod-completion",
        dependencies = { "tpope/vim-dadbod" },
        ft = { "sql", "mysql", "plsql" },
    },

    -- Wire dadbod source into blink.cmp for SQL buffer completion
    {
        "saghen/blink.cmp",
        optional = true,
        opts = {
            sources = {
                providers = {
                    dadbod = {
                        name = "Dadbod",
                        module = "vim_dadbod_completion.blink",
                    },
                },
                per_filetype = {
                    sql = { "dadbod", "buffer" },
                    mysql = { "dadbod", "buffer" },
                    plsql = { "dadbod", "buffer" },
                },
            },
        },
    },
}
