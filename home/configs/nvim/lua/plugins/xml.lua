-- XML Language tooling (LSP + Treesitter + Formatter)
-- Focused on Doctrine mappings and Symfony XML configs

return {
    -- Treesitter parser
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            opts.ensure_installed = opts.ensure_installed or {}
            vim.list_extend(opts.ensure_installed, { "xml" })
            return opts
        end,
    },

    -- LSP: lemminx (Eclipse's XML language server, mature, handles XSD validation)
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                lemminx = {
                    filetypes = { "xml", "xsd", "xsl", "xslt", "svg" },
                    settings = {
                        xml = {
                            server = { workDir = "~/.cache/lemminx" },
                            validation = {
                                enabled = true,
                                schema = true,
                                resolveExternalEntities = true,
                            },
                            completion = {
                                autoCloseTags = true,
                            },
                            format = {
                                enabled = true,
                                splitAttributes = false,
                            },
                        },
                    },
                },
            },
        },
    },

    -- Formatter
    {
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = {
                xml = { "xmllint" },
            },
        },
    },
}
