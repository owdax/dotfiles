return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        local function xcodebuild_device()
          if vim.g.xcodebuild_platform == "macOS" then
            return " macOS"
          end

          local deviceIcon = ""
          if vim.g.xcodebuild_platform:match("watch") then
            deviceIcon = "􀟤"
          elseif vim.g.xcodebuild_platform:match("tv") then
            deviceIcon = "􀡴 "
          elseif vim.g.xcodebuild_platform:match("vision") then
            deviceIcon = "􁎖 "
          end

          if vim.g.xcodebuild_os then
            return deviceIcon .. " " .. vim.g.xcodebuild_device_name .. " (" .. vim.g.xcodebuild_os .. ")"
          end

          return deviceIcon .. " " .. vim.g.xcodebuild_device_name
        end

        local function find_buildserver_json()
          local current_buf_path = vim.api.nvim_buf_get_name(0)
          local current_dir
          if current_buf_path ~= "" then
            current_dir = vim.fn.fnamemodify(current_buf_path, ':p:h')
          else
            current_dir = vim.fn.getcwd()
          end

          if not current_dir or current_dir == "" then return false end

          local workspace_root = vim.loop.cwd()
          if not workspace_root or workspace_root == "" then
            -- Fallback if cwd is somehow problematic, though unlikely
            workspace_root = vim.fn.fnamemodify(current_dir, ':p:h')
          end
          
          local tried_paths = {}
          while current_dir and current_dir ~= "" and current_dir ~= "/" and (current_dir == workspace_root or current_dir:find(workspace_root .. "/", 1, true) == 1 or workspace_root:find(current_dir .. "/", 1, true) == 1) do
            if tried_paths[current_dir] then break end -- Avoid loops
            tried_paths[current_dir] = true

            if vim.fn.filereadable(current_dir .. "/buildserver.json") == 1 then
              return true
            end
            
            if current_dir == workspace_root and not (vim.fn.fnamemodify(current_dir, ':h') :find(workspace_root .. "/", 1, true) == 1) then
                 -- If current_dir is workspace_root, and parent is not part of workspace_root (e.g. workspace_root is /foo, parent is /)
                 -- then break to avoid searching outside workspace_root if workspace_root itself is being checked.
                 -- This logic is to ensure we don't go "above" workspace_root if current_dir starts at workspace_root.
                 -- However, if current_dir is *below* workspace_root, we should be able to go up to workspace_root.
                 -- The loop condition `current_dir:find(workspace_root .. "/", 1, true) == 1` handles being inside.
                 -- The `current_dir == workspace_root` handles being exactly at workspace_root.
                 -- The `workspace_root:find(current_dir .. "/", 1, true) == 1` handles if cwd is child of project root
                 break 
            end

            local parent_dir = vim.fn.fnamemodify(current_dir, ':h')
            if parent_dir == current_dir or parent_dir == "" then
                break
            end
            current_dir = parent_dir
          end
          return false
        end

        local default_lualine_x_components = {}
        local xcode_lualine_x_components = {
          { "' ' .. (vim.g.xcodebuild_last_status or '')", color = { fg = "Gray" } },
          { "'󰙨 ' .. (vim.g.xcodebuild_test_plan or '')", color = { fg = "#a6e3a1", bg = "#161622" } },
          { xcodebuild_device, color = { fg = "#f9e2af", bg = "#161622" } },
        }

        require("lualine").setup({
            options = {
                icons_enabled = true,
                theme = "catppuccin",
                component_separators = { left = "", right = "" },
                section_separators = { left = "", right = ""},
                disabled_filetypes = {
                  statusline = {},
                  winbar = {},
                },
                ignore_focus = {},
                always_divide_middle = true,
                always_show_tabline = true,
                globalstatus = false,
                refresh = {
                  statusline = 1000, -- Adjusted refresh, default is 1000 for statusline
                  tabline = 1000,
                  winbar = 1000,
                }
              },
              sections = {
                lualine_a = {'mode' ,'filename'},
                lualine_b = {'filetype', 'diff', 'diagnostics'},
                lualine_c = {},
                lualine_x = find_buildserver_json() and xcode_lualine_x_components or default_lualine_x_components,
                lualine_y = {'branch'},
                lualine_z = {'location'}
              },
              inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {'filename'},
                lualine_x = {'location'},
                lualine_y = {},
                lualine_z = {}
              },
              tabline = {},
              winbar = {},
              inactive_winbar = {},
              extensions = {}
        })

        local lualine_augroup = vim.api.nvim_create_augroup("LualineXcodeDynamicSection", { clear = true })
        vim.api.nvim_create_autocmd({ "BufEnter", "FileType", "DirChanged" }, {
          group = lualine_augroup,
          pattern = "*",
          callback = function()
            local new_x_section
            if find_buildserver_json() then
              new_x_section = xcode_lualine_x_components
            else
              new_x_section = default_lualine_x_components
            end
            -- Check if lualine is already loaded, as set_section might error otherwise if called too early
            if package.loaded.lualine and package.loaded.lualine.set_section then
                 pcall(require('lualine').set_section, 'lualine_x', new_x_section)
            end
          end,
        })
    end
}