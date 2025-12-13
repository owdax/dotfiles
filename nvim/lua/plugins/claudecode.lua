return {
    "coder/claudecode.nvim",
    dependencies = {
        "folke/snacks.nvim",
    },
    config = function()
        require("claudecode").setup({
            -- Server Configuration
            port_range = { min = 10000, max = 65535 },
            auto_start = true,
            log_level = "info", -- "trace", "debug", "info", "warn", "error"
            -- Wrapper script to fix iTerm2 underlines in Neovim terminal
            terminal_cmd = vim.fn.stdpath("config") .. "/scripts/claude-wrapper.sh",

            -- Selection Tracking (sends current selection context to Claude)
            track_selection = true,
            visual_demotion_delay_ms = 50,

            -- Focus behavior after sending selection
            focus_after_send = true,

            -- Terminal Configuration
            terminal = {
                split_side = "bottom",
                split_height_percentage = 0.25,
                provider = "snacks", -- Uses snacks.nvim for better terminal
                auto_close = true,

                -- Floating window configuration
                snacks_win_opts = {
                    position = "bottom",
                    height = 0.35,
                    border = "rounded",
                    keys = {
                        -- Press Ctrl+, to hide terminal (can toggle back)
                        claude_hide = {
                            "<C-,>",
                            function(self)
                                self:hide()
                            end,
                            mode = "t",
                        },
                    },
                },

                -- Use git root as working directory
                cwd_provider = function(ctx)
                    -- Try to find git root, fallback to file directory
                    local git_root = vim.fn.systemlist("git -C " .. vim.fn.shellescape(ctx.file_dir) .. " rev-parse --show-toplevel")[1]
                    if vim.v.shell_error == 0 and git_root then
                        return git_root
                    end
                    return ctx.cwd
                end,
            },

            -- Diff Integration (when Claude proposes changes)
            diff_opts = {
                auto_close_on_accept = true,
                vertical_split = true,
                open_in_current_tab = true,
                keep_terminal_focus = false, -- Focus diff window to review changes
            },
        })
    end,
    keys = {
        -- Main toggle
        { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude Code" },
        { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },

        -- Session management
        { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume conversation" },
        { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue last conversation" },
        { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select model" },

        -- Context management
        { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
        { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection to Claude" },

        -- Diff actions
        { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
        { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },

        -- Status check
        { "<leader>ai", "<cmd>ClaudeCodeStatus<cr>", desc = "Connection status" },
    },
}
