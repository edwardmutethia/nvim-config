return {
  "akinsho/toggleterm.nvim",
  version = "*",
  keys = {
    { "<C-\\>", "<cmd>ToggleTerm<CR>", desc = "Toggle terminal" },
    { "<C-`>", "<cmd>ToggleTerm<CR>", desc = "Toggle terminal (VSCode style)" },
    { "<leader>tt", "<cmd>ToggleTerm direction=float<CR>", desc = "Floating terminal" },
    { "<leader>tg", function() _G._lazygit_toggle() end, desc = "Lazygit" },
  },
  opts = {
    size = 20,
    direction = "horizontal",
    -- No extra tint: the panel shares the editor's background so it blends in.
    shade_terminals = false,
    float_opts = { border = "rounded" },
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
