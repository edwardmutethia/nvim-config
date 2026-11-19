return {
  "akinsho/toggleterm.nvim",
  version = "*",
  keys = {
    { "<C-\\>", "<cmd>ToggleTerm<CR>", desc = "Toggle terminal" },
    { "<leader>tt", "<cmd>ToggleTerm direction=float<CR>", desc = "Floating terminal" },
    { "<leader>tg", function() _G._lazygit_toggle() end, desc = "Lazygit" },
  },
  opts = {
    size = 20,
    direction = "horizontal",
    shade_terminals = true,
    float_opts = { border = "curvy" },
  },
  config = function(_, opts)
    require("toggleterm").setup(opts)

    local Terminal = require("toggleterm.terminal").Terminal
    local lazygit = Terminal:new({
      cmd = "lazygit",
      hidden = true,
      direction = "float",
      close_on_exit = true,
    })

    function _G._lazygit_toggle()
      lazygit:toggle()
    end
  end,
}
