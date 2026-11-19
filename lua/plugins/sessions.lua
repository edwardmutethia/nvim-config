return {
  "folke/persistence.nvim",
  event = "BufReadPre",
  keys = {
    { "<leader>ss", function() require("persistence").save() end, desc = "Save session" },
    { "<leader>sl", function() require("persistence").load() end, desc = "Restore session" },
    { "<leader>sr", function() require("persistence").load({ last = true }) end, desc = "Restore last session" },
    { "<leader>sx", function() require("persistence").stop() end, desc = "Stop session tracking" },
  },
  opts = {
    options = "buffers,curdir,folds,help,tabpages,winsize,winpos,terminal",
  },
}
