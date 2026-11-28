return {
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    config = function()
      local notify = require("notify")
      notify.setup({
        stages = "fade",
        timeout = 3000,
        max_height = function()
          return math.floor(vim.o.lines * 0.75)
        end,
        max_width = function()
          return math.floor(vim.o.columns * 0.5)
        end,
      })
      -- Noice owns vim.notify and forwards these notifications to this
      -- nvim-notify view, so don't replace its handler here.
    end,
  },
}
