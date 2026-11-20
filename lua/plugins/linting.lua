-- Rust linting is handled by rust-analyzer/clippy, C/C++ get clang-tidy
-- diagnostics from clangd, and JS/TS/React use eslint-lsp. Keeping those in
-- their language servers avoids duplicate diagnostics from nvim-lint.
return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      lua = { "selene" },
      python = { "ruff" },
      go = { "golangcilint" },
      html = { "htmlhint" },
      css = { "stylelint" },
      scss = { "stylelint" },
      less = { "stylelint" },
      java = { "checkstyle" },
      sql = { "sqlfluff" },
    }

    -- Point selene at our config so Neovim globals don't raise false warnings.
    lint.linters.selene.args = {
      "--display-style", "json",
      "--config", vim.fn.stdpath("config") .. "/selene.toml",
      "-",
    }

    -- Use the bundled Google checks if Mason installed them at a known path.
    local checkstyle_configs = vim.fn.glob(
      vim.fn.stdpath("data") .. "/mason/packages/checkstyle/**/google_checks.xml",
      true,
      true
    )
    if #checkstyle_configs > 0 then
      lint.linters.checkstyle.config_file = checkstyle_configs[1]
    end

    local group = vim.api.nvim_create_augroup("lint_on_save", { clear = true })
    vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
      group = group,
      callback = function()
        pcall(lint.try_lint)
      end,
    })
  end,
}
