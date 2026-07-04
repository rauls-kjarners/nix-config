return {
    {
        "Mofiqul/dracula.nvim",
        lazy = false,
        priority = 1000,
    },
    {
        "jaljoue/dracula-alucard.nvim",
        lazy = true, -- loaded on demand by auto-dark-mode when switching to light
    },
    {
        "f-person/auto-dark-mode.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            update_interval = 1000,
            set_dark_mode = function()
                vim.api.nvim_set_option_value("background", "dark", {})
                pcall(vim.cmd, "colorscheme dracula")
            end,
            set_light_mode = function()
                vim.api.nvim_set_option_value("background", "light", {})
                pcall(vim.cmd, "colorscheme dracula-alucard")

                -- Fix Neotest contrast for Alucard (Light Mode)
                -- Using official Alucard palette colors for perfect visual integration
                vim.schedule(function()
                    vim.api.nvim_set_hl(0, "NeotestPassed", { fg = "#14710A", bold = true }) -- Alucard green
                    vim.api.nvim_set_hl(0, "NeotestFailed", { fg = "#CB3A2A", bold = true }) -- Alucard red
                    vim.api.nvim_set_hl(0, "NeotestRunning", { fg = "#A34D14", bold = true }) -- Alucard orange
                    vim.api.nvim_set_hl(0, "NeotestSkipped", { fg = "#846E15", bold = true }) -- Alucard yellow
                    vim.api.nvim_set_hl(0, "NeotestWatching", { fg = "#846E15", bold = true }) -- Alucard yellow
                    vim.api.nvim_set_hl(0, "NeotestDir", { fg = "#644AC9", bold = true }) -- Alucard purple
                    vim.api.nvim_set_hl(0, "NeotestFile", { fg = "#1F1F1F", bold = true }) -- Alucard fg
                    vim.api.nvim_set_hl(0, "NeotestNamespace", { fg = "#A3144D", bold = true }) -- Alucard pink
                    vim.api.nvim_set_hl(0, "NeotestAdapterName", { fg = "#644AC9", bold = true }) -- Alucard purple
                    vim.api.nvim_set_hl(0, "NeotestMarked", { fg = "#C43F6E", bold = true }) -- Alucard bright_magenta
                    vim.api.nvim_set_hl(0, "NeotestIndent", { fg = "#6C664B" }) -- Alucard comment
                    vim.api.nvim_set_hl(0, "NeotestExpandMarker", { fg = "#9B9278" }) -- Alucard gutter_fg

                    -- Fix Glance panel colors for Alucard (Light Mode)
                    -- Glance's auto-darken computes mid-grays from #FFFBEB; pin to warm palette instead.
                    --   Preview (code view): inlay_hint_bg — barely off-white so code looks natural
                    --   List   (refs panel): menu          — clearly distinct from preview
                    --   WinBar (header strip): visual      — darker band for separation
                    local p_bg = "#F8F5E8" -- inlay_hint_bg
                    local l_bg = "#F5F1E3" -- menu
                    local wb_bg = "#E8E4D8" -- visual
                    local fg = "#1F1F1F" -- fg
                    local muted = "#6C664B" -- comment
                    local dim = "#9B9278" -- gutter_fg
                    vim.api.nvim_set_hl(0, "GlancePreviewNormal", { fg = fg, bg = p_bg })
                    vim.api.nvim_set_hl(0, "GlancePreviewEndOfBuffer", { fg = p_bg, bg = p_bg })
                    vim.api.nvim_set_hl(0, "GlancePreviewBorderBottom", { fg = dim, bg = p_bg })
                    vim.api.nvim_set_hl(0, "GlancePreviewLineNr", { fg = dim, bg = p_bg })
                    vim.api.nvim_set_hl(0, "GlancePreviewSignColumn", { fg = p_bg, bg = p_bg })
                    vim.api.nvim_set_hl(0, "GlanceListNormal", { fg = fg, bg = l_bg })
                    vim.api.nvim_set_hl(0, "GlanceListEndOfBuffer", { fg = l_bg, bg = l_bg })
                    vim.api.nvim_set_hl(0, "GlanceListBorderBottom", { fg = dim, bg = l_bg })
                    vim.api.nvim_set_hl(0, "GlanceListFilepath", { fg = muted, bg = l_bg })
                    vim.api.nvim_set_hl(0, "GlanceFoldIcon", { fg = muted, bg = l_bg })
                    vim.api.nvim_set_hl(0, "GlanceIndent", { fg = dim })
                    vim.api.nvim_set_hl(0, "GlanceWinBarFilename", { fg = fg, bg = wb_bg, bold = true })
                    vim.api.nvim_set_hl(0, "GlanceWinBarFilepath", { fg = muted, bg = wb_bg })
                    vim.api.nvim_set_hl(0, "GlanceWinBarTitle", { fg = "#644AC9", bg = wb_bg, bold = true }) -- Alucard purple
                    vim.api.nvim_set_hl(0, "GlanceBorderTop", { fg = dim, bg = wb_bg })
                    vim.api.nvim_set_hl(0, "GlancePreviewCursorLine", { bg = "#CFCFDE" }) -- selection
                    vim.api.nvim_set_hl(0, "GlanceListCursorLine", { bg = "#CFCFDE" }) -- selection
                end)
            end,
        },
    },
    {
        "LazyVim/LazyVim",
        opts = function(_, opts)
            opts = type(opts) == "table" and opts or {}
            opts.colorscheme = vim.env.BAT_THEME == "Alucard" and "dracula-alucard" or "dracula"
            return opts
        end,
    },
}
