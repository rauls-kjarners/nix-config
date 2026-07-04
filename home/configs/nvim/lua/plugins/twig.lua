-- Twig template support (Symfony)
-- 1. Treesitter parser for syntax highlighting
-- 2. twiggy-language-server for basic completion/hover (limited but usable, handled by Mason)
-- 3. prettier-plugin-twig is handled by formatting.prettier extra (conform)

return {
    -- Twig treesitter grammar
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            opts.ensure_installed = opts.ensure_installed or {}
            vim.list_extend(opts.ensure_installed, { "twig" })
            return opts
        end,
    },

    -- Twig LSP (basic: snippets, completion, hover — no full type analysis available)
    {
        "neovim/nvim-lspconfig",
        opts = function(_, opts)
            -- Register twiggy-language-server (not in default lspconfig registry)
            local configs = require("lspconfig.configs")
            if not configs.twiggy_language_server then
                configs.twiggy_language_server = {
                    default_config = {
                        cmd = { "twiggy-language-server", "--stdio" },
                        filetypes = { "twig", "html.twig" },
                        root_dir = require("lspconfig.util").root_pattern("composer.json", ".git"),
                        single_file_support = true,
                    },
                }
            end

            opts.servers = opts.servers or {}
            opts.servers.twiggy_language_server = {}
            return opts
        end,
    },
}
