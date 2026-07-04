return {
    {
        "nvim-lualine/lualine.nvim",
        opts = function(_, opts)
            opts.options = opts.options or {}
            -- Use the string "auto" so lualine re-derives colors on every colorscheme change.
            -- (Pinning a snapshot table would freeze colors at startup.)
            opts.options.theme = "auto"
            return opts
        end,
        config = function(_, opts)
            require("lualine").setup(opts)

            -- Alucard light contrast fix: the auto theme can use dim colors for statusline text
            -- in light mode. Override to the official Alucard foreground (#1f1f1f) for readability.
            --
            -- Uses nvim_set_hl (not table mutation) so toggling back to dark gets a clean slate —
            -- lualine regenerates hl groups from scratch on the next ColorScheme event.
            -- vim.schedule runs after lualine has finished regenerating its groups.
            local function apply_alucard_fg()
                if vim.o.background ~= "light" then
                    return
                end
                local fg = "#1f1f1f"
                local groups = {
                    "lualine_a_normal",
                    "lualine_z_normal",
                    "lualine_b_normal",
                    "lualine_c_normal",
                    "lualine_x_normal",
                    "lualine_y_normal",
                    "lualine_b_insert",
                    "lualine_c_insert",
                    "lualine_x_insert",
                    "lualine_y_insert",
                    "lualine_b_visual",
                    "lualine_c_visual",
                    "lualine_x_visual",
                    "lualine_y_visual",
                    "lualine_b_replace",
                    "lualine_c_replace",
                    "lualine_x_replace",
                    "lualine_y_replace",
                    "lualine_b_command",
                    "lualine_c_command",
                    "lualine_x_command",
                    "lualine_y_command",
                }
                for _, group in ipairs(groups) do
                    local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
                    if ok and hl then
                        hl.fg = fg
                        vim.api.nvim_set_hl(0, group, hl)
                    end
                end
            end

            vim.api.nvim_create_autocmd("ColorScheme", {
                callback = function()
                    vim.schedule(apply_alucard_fg)
                end,
            })
            -- Apply immediately in case colorscheme is already loaded
            vim.schedule(apply_alucard_fg)
        end,
    },
}
