return {
    {
        "folke/snacks.nvim",
        opts = {
            picker = {
                sources = {
                    explorer = {
                        hidden = true,
                        layout = {
                            preview = true,
                            layout = {
                                box = "vertical",
                                position = "left",
                                border = "none",
                                backdrop = false,
                                height = 0,
                                width = 60,
                                { win = "input", height = 1, border = "bottom" },
                                { win = "list", border = "none" },
                                { win = "preview", title = "{preview}", height = 0.6, border = "top" },
                            },
                        },
                    }, -- <leader>e (File Explorer)
                    files = { hidden = true }, -- <leader>ff (Find Files)
                    smart = { hidden = true }, -- <leader><space> (Smart Find Files)
                },
            },
            terminal = {
                win = {
                    keys = {
                        nav_h = false,
                        nav_j = { "<C-j>", function(self) return self:is_floating() and "<C-j>" or vim.schedule(function() vim.cmd.wincmd("h") end) end, desc = "Go to Left Window", expr = true, mode = "t" },
                        nav_k = { "<C-k>", function(self) return self:is_floating() and "<C-k>" or vim.schedule(function() vim.cmd.wincmd("j") end) end, desc = "Go to Lower Window", expr = true, mode = "t" },
                        nav_l = { "<C-l>", function(self) return self:is_floating() and "<C-l>" or vim.schedule(function() vim.cmd.wincmd("k") end) end, desc = "Go to Upper Window", expr = true, mode = "t" },
                        nav_semi = { "<C-;>", function(self) return self:is_floating() and "<C-;>" or vim.schedule(function() vim.cmd.wincmd("l") end) end, desc = "Go to Right Window", expr = true, mode = "t" },
                    },
                },
            },
            styles = {
                lazygit = {
                    width = 0,
                    height = 0,
                },
            },
        },
    },
}
