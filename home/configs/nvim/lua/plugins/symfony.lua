-- Symfony-specific pickers
-- <leader>pR: fuzzy-search all routes → jump to controller
-- <leader>pS: fuzzy-search all services → jump to class
--
-- Requires: php bin/console available from CWD (i.e. you're in a Symfony project root)
-- Both pickers warn gracefully if not in a Symfony project.

return {
    {
        "folke/snacks.nvim",
        optional = true,
        keys = {
            -- Symfony Routes picker
            {
                "<leader>pR",
                function()
                    local raw = vim.fn.system("php bin/console debug:router --format=json 2>/dev/null")
                    local ok, parsed = pcall(vim.json.decode, raw)
                    if not ok or type(parsed) ~= "table" then
                        vim.notify(
                            "Symfony routes: not in a Symfony project or bin/console failed",
                            vim.log.levels.WARN
                        )
                        return
                    end

                    local items = {}
                    for name, info in pairs(parsed) do
                        local path = info.path or ""
                        local controller = (info.defaults or {})._controller or ""
                        table.insert(items, {
                            text = string.format("%-50s %s", name, path),
                            name = name,
                            controller = controller,
                        })
                    end
                    table.sort(items, function(a, b)
                        return a.name < b.name
                    end)

                    require("snacks").picker({
                        title = "Symfony Routes",
                        items = items,
                        format = function(item)
                            return { { item.text } }
                        end,
                        confirm = function(picker, item)
                            picker:close()
                            if item and item.controller ~= "" then
                                vim.lsp.buf.workspace_symbol(item.controller)
                            end
                        end,
                    })
                end,
                desc = "Symfony: routes",
            },

            -- Symfony Services picker
            {
                "<leader>pS",
                function()
                    local raw = vim.fn.system("php bin/console debug:container --format=json 2>/dev/null")
                    local ok, parsed = pcall(vim.json.decode, raw)
                    if not ok or type(parsed) ~= "table" then
                        vim.notify(
                            "Symfony services: not in a Symfony project or bin/console failed",
                            vim.log.levels.WARN
                        )
                        return
                    end

                    local items = {}
                    for id, info in pairs(parsed) do
                        local class = info.class or ""
                        table.insert(items, {
                            text = string.format("%-60s %s", id, class),
                            id = id,
                            class = class,
                        })
                    end
                    table.sort(items, function(a, b)
                        return a.id < b.id
                    end)

                    require("snacks").picker({
                        title = "Symfony Services",
                        items = items,
                        format = function(item)
                            return { { item.text } }
                        end,
                        confirm = function(picker, item)
                            picker:close()
                            if item and item.class ~= "" then
                                vim.lsp.buf.workspace_symbol(item.class)
                            end
                        end,
                    })
                end,
                desc = "Symfony: services",
            },
        },
    },
}
