-- Persistent undo tree (Local History replacement)
-- vim.opt.undofile and undodir are set in options.lua
-- undotree visualizes the full branching undo history across restarts

return {
    {
        "mbbill/undotree",
        cmd = "UndotreeToggle",
        keys = {
            { "<leader>uu", "<cmd>UndotreeToggle<cr>", desc = "Undo tree" },
        },
    },
}
