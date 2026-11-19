-- Rust linting is handled by rust-analyzer with `check.command = "clippy"`
-- (see lua/plugins/lsp-config.lua). Lua uses selene through nvim-lint.
return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      lua = { "selene" },
    }

    -- Point selene at our config so Neovim globals don't raise false warnings.
    lint.linters.selene.args = {
      "--display-style", "json",
      "--config", vim.fn.stdpath("config") .. "/selene.toml",
      "-",
    }

    local group = vim.api.nvim_create_augroup("lint_on_save", { clear = true })
    vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
      group = group,
      callback = function()
        pcall(lint.try_lint)
      end,
    })
  end,
}
