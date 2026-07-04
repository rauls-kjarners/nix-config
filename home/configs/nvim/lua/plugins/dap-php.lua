-- PHP / Xdebug debugging
-- Builds on top of LazyVim's dap.core extra (nvim-dap + nvim-dap-ui)
-- Adds: nvim-dap-virtual-text (inline values) + PHP/Xdebug adapter config
--
-- The PHP adapter uses vscode-php-debug via Mason (package: php-debug-adapter)
-- Mason installs it at: stdpath("data")/mason/packages/php-debug-adapter/
--
-- Path mappings default to /var/www → workspace root (common Docker setup).
-- Override per-project in a .nvim.lua file at the project root.

return {
    -- Ensure Mason installs the PHP debug adapter
    {
        "mason-org/mason.nvim",
        opts = function(_, opts)
            opts.ensure_installed = opts.ensure_installed or {}
            vim.list_extend(opts.ensure_installed, { "php-debug-adapter" })
            return opts
        end,
    },

    -- Inline variable values shown next to code during a debug session
    {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
    },

    -- PHP/Xdebug adapter configuration
    {
        "mfussenegger/nvim-dap",
        optional = true,
        config = function()
            local dap = require("dap")

            dap.adapters.php = {
                type = "executable",
                command = "node",
                args = {
                    vim.fn.stdpath("data") .. "/mason/packages/php-debug-adapter/extension/out/phpDebug.js",
                },
            }

            dap.configurations.php = {
                {
                    type = "php",
                    request = "launch",
                    name = "Listen for Xdebug (Docker: /var/www)",
                    port = 9003,
                    pathMappings = {
                        ["/var/www"] = "${workspaceFolder}",
                    },
                },
                {
                    type = "php",
                    request = "launch",
                    name = "Listen for Xdebug (local)",
                    port = 9003,
                },
            }
        end,
    },
}
