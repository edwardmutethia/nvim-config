-- Layout-preserving buffer close. Replaces plain :bdelete so splits and
-- terminal windows stay where they are when a buffer is closed.
return {
  "nvim-mini/mini.bufremove",
  version = "*",
  keys = {
    {
      "<leader>wq",
      function()
        require("mini.bufremove").delete(0, false)
      end,
      desc = "Close buffer (keep layout)",
    },
    {
      "<leader>wQ",
      function()
        require("mini.bufremove").delete(0, true)
      end,
      desc = "Force close buffer (keep layout)",
    },
  },
  config = function()
    require("mini.bufremove").setup({ silent = true })
  end,
}
