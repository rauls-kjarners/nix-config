-- Testing: neotest with PHPUnit and Pest adapters
-- Extends LazyVim's test.core extra (which provides neotest + UI keymaps)

return {
    {
        "nvim-neotest/neotest",
        dependencies = {
            "olimorris/neotest-phpunit",
        },
        keys = {
            {
                "<leader>tF",
                function()
                    require("neotest").run.run({ status = "failed" })
                end,
                desc = "Run Failed Tests (Neotest)",
            },
            {
                "<leader>tp",
                function()
                    vim.ui.input(
                        { prompt = "Number of paratest processes: ", default = tostring(vim.g.paratest_processes or 6) },
                        function(input)
                            if input and tonumber(input) then
                                vim.g.paratest_processes = tonumber(input)
                                vim.notify("Paratest processes set to " .. input)
                            end
                        end
                    )
                end,
                desc = "Set Paratest Processes",
            },
        },
        opts = function(_, opts)
            opts.adapters = opts.adapters or {}
            opts.discovery = {
                concurrent = 0,
                filter_dir = function(name, rel_path, root)
                    return rel_path == "tests" or string.match(rel_path, "^tests/") ~= nil
                end,
            }
            vim.list_extend(opts.adapters, {
                require("neotest-phpunit")({
                    phpunit_cmd = function()
                        return vim.fn.expand("~/.local/bin/neotest-remote")
                    end,
                    env = function()
                        return {
                            PARATEST_PROCESSES = tostring(vim.g.paratest_processes or 6),
                        }
                    end,
                }),
            })
            return opts
        end,
    },
}
