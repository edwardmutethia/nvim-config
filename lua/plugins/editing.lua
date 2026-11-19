return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      spec = {
        { "<leader>c", group = "code" },
        { "<leader>d", group = "debug" },
        { "<leader>e", group = "explorer" },
        { "<leader>f", group = "find" },
        { "<leader>g", group = "git" },
        { "<leader>h", group = "hunks" },
        { "<leader>s", group = "session" },
        { "<leader>t", group = "terminal / toggle" },
        { "<leader>u", group = "ui" },
        { "<leader>w", group = "buffer / write" },
        { "<leader>x", group = "diagnostics" },
      },
    },
    keys = {
      { "<leader>?", function() require("which-key").show({ global = true }) end, desc = "Show all keymaps" },
    },
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    dependencies = { "hrsh7th/nvim-cmp" },
    opts = {},
    config = function(_, opts)
      require("nvim-autopairs").setup(opts)
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },
  {
    "numToStr/Comment.nvim",
    keys = { { "gc", mode = { "n", "v" }, desc = "Toggle comment" }, { "gcc", desc = "Toggle line comment" } },
    opts = {},
  },
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", function() require("flash").jump() end, mode = { "n", "x", "o" }, desc = "Flash jump" },
      { "S", function() require("flash").treesitter() end, mode = { "n", "x", "o" }, desc = "Flash treesitter" },
      { "r", function() require("flash").remote() end, mode = "o", desc = "Remote flash" },
      { "R", function() require("flash").treesitter_search() end, mode = { "o", "x" }, desc = "Flash treesitter search" },
    },
  },
}
