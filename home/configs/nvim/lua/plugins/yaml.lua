-- YAML tooling enhancements
-- LazyVim's lang.yaml extra already handles yamlls, formatting, and SchemaStore.nvim
-- This file adds path display for deeply nested YAML configs (like Symfony services)

return {
    {
        "cuducos/yaml.nvim",
        ft = { "yaml" },
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        cmd = { "YAMLView", "YAMLYank", "YAMLYankKey", "YAMLYankValue" },
        keys = {
            { "<leader>cy", "<cmd>YAMLView<cr>", desc = "YAML: View Path" },
            { "<leader>cY", "<cmd>YAMLYank<cr>", desc = "YAML: Yank Path" },
        },
    },
}
