-- Project-wide search and replace with a preview before applying changes.
return {
  "MagicDuck/grug-far.nvim",
  cmd = { "GrugFar", "GrugFarWithin" },
  keys = {
    {
      "<leader>fR",
      function()
        require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
      end,
      desc = "Find and replace word in files",
    },
    {
      "<leader>fR",
      function()
        require("grug-far").open()
      end,
      mode = "v",
      desc = "Find and replace selection in files",
    },
    {
      "<leader>fF",
      function()
        require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } })
      end,
      desc = "Find and replace in current file",
    },
  },
  opts = {},
}
