-- php-lsp (primary) or intelephense (fallback) + phpactor (refactorings only)

return {
    -- 1. LSP: php-lsp (primary), intelephense (fallback) + phpactor (refactorings, no diagnostics)
    {
        "neovim/nvim-lspconfig",
        opts = function(_, opts)
            local has_phplsp = vim.fn.exepath("php-lsp") ~= ""

            opts.servers = opts.servers or {}
            -- Explicitly disable LazyVim's default phpactor to stop Mason auto-install
            opts.servers.phpactor = { enabled = false }

            if has_phplsp then
                -- Disable the LazyVim default intelephense
                opts.servers.intelephense = { enabled = false }

                opts.servers["php-lsp"] = {
                    cmd = { "php-lsp" },
                    filetypes = { "php" },
                    root_dir = require("lspconfig.util").root_pattern("composer.json", ".git"),
                    autostart = true,
                }
            else
                -- intelephense: fallback if php-lsp is not present
                opts.servers.intelephense = opts.servers.intelephense or {}
                opts.servers.intelephense.enabled = true
                opts.servers.intelephense.settings = {
                    intelephense = {
                        environment = {
                            includePaths = {
                                "vendor/rector/rector/vendor/rector",
                                "var/cache/dev/Symfony/Config",
                            },
                        },
                        files = {
                            exclude = {
                                "**/.git",
                                "**/node_modules",
                                "**/vendor/**/{Tests,tests}",
                                "**/.history",
                                "**/vendor/**/vendor",
                                "**/var",
                                "**/build",
                                "**/public/bundles",
                            },
                        },
                    },
                }
            end

            opts.setup = opts.setup or {}
            opts.setup["php-lsp"] = function(_, server_opts)
                local configs = require("lspconfig.configs")
                if not configs["php-lsp"] then
                    configs["php-lsp"] = { default_config = server_opts }
                end
                require("lspconfig")["php-lsp"].setup(server_opts)
                return true
            end

            -- Autocommand for LSP tweaks
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("php_lsp_tweaks", { clear = true }),
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    -- Disable pull diagnostics for php-lsp to prevent duplicate push/pull diagnostics
                    if client and client.name == "php-lsp" then
                        client.server_capabilities.diagnosticProvider = false
                    end
                end,
            })

            return opts
        end,
    },

    -- 2. Disable default phpcs linter
    {
        "mfussenegger/nvim-lint",
        opts = function(_, opts)
            opts.linters_by_ft = opts.linters_by_ft or {}
            opts.linters_by_ft.php = {}
            return opts
        end,
    },

    -- 3. php-cs-fixer as formatter (via conform)
    {
        "stevearc/conform.nvim",
        opts = function(_, opts)
            opts.formatters_by_ft = opts.formatters_by_ft or {}
            -- Falls back to vendor/bin/php-cs-fixer or global install
            opts.formatters_by_ft.php = { "php_cs_fixer" }
            return opts
        end,
    },
}
