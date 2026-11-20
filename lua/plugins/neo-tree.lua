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
}
