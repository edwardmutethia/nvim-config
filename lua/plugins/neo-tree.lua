return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    { "<C-n>", "<cmd>Neotree filesystem reveal left<CR>", desc = "Toggle file explorer" },
    { "<leader>en", "<cmd>Neotree filesystem reveal left<CR>", desc = "Toggle file explorer" },
    { "<leader>eb", "<cmd>Neotree buffers reveal left<CR>", desc = "Toggle buffer list" },
    { "<leader>eg", "<cmd>Neotree git_status reveal left<CR>", desc = "Toggle git status" },
  },
  opts = {
    sources = { "filesystem", "buffers", "git_status" },
    source_selector = {
      winbar = false,
      statusline = false,
    },
    window = {
      width = 36,
      mappings = {
        ["q"] = "close_window",
        ["<C-n>"] = "close_window",
        -- Use a real window for previews so Markdown buffers keep their
        -- filetype and render-markdown can show the rendered README.
        ["P"] = {
          "toggle_preview",
          config = { use_float = false, use_snacks_image = false, use_image_nvim = false },
        },
      },
    },
    filesystem = {
      follow_current_file = { enabled = true, leave_dirs_open = true },
      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = true,
        never_show = { ".git" },
      },
    },
    default_component_configs = {
      git_status = {
        symbols = {
          added = "+",
          deleted = "-",
          modified = "~",
          renamed = "r",
          untracked = "?",
          ignored = "!",
          unstaged = "✗",
          staged = "✓",
          conflict = "≠",
        },
      },
    },
  },
  config = function(_, opts)
    require("neo-tree").setup(opts)

    local events = require("neo-tree.events")
    local manager = require("neo-tree.sources.manager")
    local Preview = require("neo-tree.sources.common.preview")
    local commands = require("neo-tree.sources.common.commands")

    -- Preview the file in a real window so its Markdown filetype is kept and
    -- render-markdown can display the rendered README.
    local preview_config = { use_float = false, use_snacks_image = false, use_image_nvim = false }

    -- README files are previewed as soon as the cursor lands on them.
    -- Non-README nodes close the preview, and Enter still opens the file in
    -- the same window for editing, so the transition stays in place.
    events.subscribe({
      event = events.VIM_CURSOR_MOVED,
      id = "readme-preview",
      handler = function()
        local state = manager.get_state("filesystem")
        if not state or not state.winid or state.winid ~= vim.api.nvim_get_current_win() then
          return
        end

        local node = state.tree and state.tree:get_node()
        local path = node and (node.path or node:get_id())
        local is_readme = path and vim.fn.fnamemodify(path, ":t"):lower():match("^readme") ~= nil

        if is_readme then
          if not Preview.is_active() then
            local preview_state = vim.tbl_extend("force", {}, state)
            preview_state.config = preview_config
            commands.toggle_preview(preview_state)
          end
        elseif Preview.is_active() then
          Preview.hide()
        end
      end,
    })
  end,
}
