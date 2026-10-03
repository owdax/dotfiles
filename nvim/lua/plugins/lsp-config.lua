return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "pylsp" },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            { "antosha417/nvim-lsp-file-operations", config = true },
        },
        config = function()
            vim.diagnostic.config({ virtual_text = true })

            local cmp_nvim_lsp = require("cmp_nvim_lsp")
            local capabilities = cmp_nvim_lsp.default_capabilities()

            -- Set default capabilities for all LSP servers
            vim.lsp.config("*", {
                capabilities = capabilities,
            })

            -- Configure individual servers
            vim.lsp.config("sourcekit", {
                cmd = { vim.trim(vim.fn.system("xcrun -f sourcekit-lsp")) },
                root_markers = { "buildServer.json", "Package.swift", ".git" },
            })

            vim.lsp.config("lua_ls", {})
            vim.lsp.config("pylsp", {})

            -- Enable all servers
            vim.lsp.enable({ "sourcekit", "lua_ls", "pylsp" })

            -- Keybindings on LspAttach
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(ev)
                    local bufnr = ev.buf
                    local map = function(mode, lhs, rhs, desc)
                        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, noremap = true, silent = true, desc = desc })
                    end

                    map("n", "gd", "<cmd>Telescope lsp_definitions trim_text=true<cr>", "Show LSP definitions")
                    map("n", "gD", "<cmd>vsplit | Telescope lsp_definitions trim_text=true<cr>", "Show LSP definitions in split")
                    map("n", "gr", "<cmd>Telescope lsp_references trim_text=true include_declaration=false<cr>", "Show LSP references")
                    map("n", "gi", "<cmd>Telescope lsp_implementations<cr>", "Show LSP implementation")
                    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Show LSP code actions")
                    map("n", "<leader>rn", vim.lsp.buf.rename, "Smart rename")
                    map("n", "<leader><leader>d", "<cmd>Telescope diagnostics bufnr=0<CR>", "Show buffer diagnostics")
                    map("n", "[d", function()
                        vim.diagnostic.jump({ count = -1 })
                        vim.cmd("normal! zz")
                    end, "Go to previous diagnostic")
                    map("n", "]d", function()
                        vim.diagnostic.jump({ count = 1 })
                        vim.cmd("normal! zz")
                    end, "Go to next diagnostic")
                    map("n", "K", vim.lsp.buf.hover, "Show documentation for what is under cursor")
                    map("n", "<leader>rl", ":LspRestart | LspStart<CR>", "Restart LSP")
                end,
            })

            vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { noremap = true, silent = true, desc = "Show line diagnostics" })
        end,
    },
}
