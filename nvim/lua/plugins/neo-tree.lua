return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
        -- "3rd/image.nvim", -- Optional: for image previews if you want them
    },
    config = function()
        -- Define the custom highlight group for indent markers
        vim.cmd([[highlight NeoTreeIndentMarker guifg=#f5c2e7]])

        require("neo-tree").setup({
            close_if_last_window = false, -- Prevent auto-closing if it's the last window
            popup_border_style = "rounded", -- Or "single", "double", "shadow"
            enable_git_status = true,
            enable_diagnostics = true,
            default_component_configs = {
                indent = {
                    indent_size = 2,
                    padding = 1,
                    -- indent_marker = "│", -- Uses default if not set
                    -- last_indent_marker = "└", -- Uses default if not set
                    highlight = "NeoTreeIndentMarker", -- Use our custom highlight group
                },
                -- icon = {
                --     folder_closed = "▸", -- Thinner arrow
                --     folder_open = "▾",  -- Thinner arrow
                --     folder_empty = "▸",
                --     folder_empty_open = "▾",
                --     -- Uses nvim-web-devicons for file icons by default
                -- },
                name = {
                    trailing_slash = true,
                    use_git_status_colors = true,
                    highlight = "NeoTreeFileName", -- Default, or customize
                },
                git_status = {
                    symbols = {
                        -- You can customize these to better match Catppuccin if desired
                        added     = "✚",
                        deleted   = "✖",
                        modified  = "●",
                        renamed   = "➜",
                        untracked = "",
                        ignored   = "◌",
                        unstaged  = "◆",
                        staged    = "✔",
                        conflict  = "",
                    },
                },
            },
            window = {
                position = "left",
                width = 40, -- From your nvim-tree config
                mapping_options = {
                    noremap = true,
                    nowait = true,
                },
                mappings = {
                    -- Default mappings are generally good.
                    -- ["<CR>"] = "open", -- Default behavior is to open and keep tree
                    -- ["o"] = "open",
                    -- ["<leader>e"] = "toggle", -- This is handled by the global keymap below
                },
                win_options = { -- Apply Vim window options
                    relativenumber = true, -- From your nvim-tree config
                    signcolumn = "no", -- Often preferred for a cleaner look
                }
            },
            filesystem = {
                filtered_items = {
                    visible = true, -- Show hidden files and gitignored files by default
                    hide_dotfiles = false,       -- Consistent with your neo-tree.lua
                    hide_gitignored = false,     -- Consistent with your neo-tree.lua
                    hide_by_name = {
                        ".DS_Store",          -- From your nvim-tree config
                        "thumbs.db",
                        -- "__pycache__", -- Example
                    },
                    always_show = { -- Ensure these are never hidden by other rules
                        -- ".gitconfig",
                    },
                    never_show = { -- Ensure these are always hidden
                        -- ".git", -- Already default
                    },
                },
                follow_current_file = {
                    enabled = true,           -- Similar to nvim-tree's update_focused_file
                    leave_dirs_open = false,  -- Close directories when navigating away
                },
                group_empty_dirs = false, -- Set to true if you want to group empty dirs
                hijack_netrw_behavior = "open_current", -- Recommended to replace netrw
                use_libuv_file_watcher = true, -- For auto-refreshing the tree
            },
            -- You can add other sources like 'buffers', 'git_status' (as a tree) if you like
            -- sources = {"filesystem", "buffers", "git_status"},
            -- source_selector = {
            --     winbar = true, -- Requires Neovim 0.8+
            --     statusline = false
            -- }
        })

        -- Set the keymap for toggling Neo-tree (same as your nvim-tree)
        vim.keymap.set('n', '<leader>e', ':Neotree toggle<CR>', { desc = "Toggle Neo-tree" })
        -- You can add other keymaps here, for example:
        -- vim.keymap.set('n', '<leader>of', ':Neotree focus<CR>', { desc = "Focus Neo-tree" })
        -- vim.keymap.set('n', '<leader>oc', ':Neotree close<CR>', { desc = "Close Neo-tree" })
        -- vim.keymap.set('n', '<leader>er', ':Neotree reveal<CR>', { desc = "Reveal current file in Neo-tree" })
    end
}
