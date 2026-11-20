-- nvim-jdtls provides Java-specific LSP commands and registers the Java DAP
-- adapter. It is the only owner of the `jdtls` client.
return {
  "mfussenegger/nvim-jdtls",
  lazy = false,
  dependencies = {
    "neovim/nvim-lspconfig",
    "mfussenegger/nvim-dap",
  },
  config = function()
    local jdtls = require("jdtls")
    local mason_share = vim.fn.stdpath("data") .. "/mason/share"

    local bundles = {}
    local debug_jars = vim.fn.glob(
      mason_share .. "/java-debug-adapter/com.microsoft.java.debug.plugin.jar",
      true,
      true
    )
    vim.list_extend(bundles, debug_jars)

    for _, jar in ipairs(vim.fn.glob(mason_share .. "/java-test/*.jar", true, true)) do
      local name = vim.fn.fnamemodify(jar, ":t")
      if name ~= "com.microsoft.java.test.runner-jar-with-dependencies.jar"
        and name ~= "jacocoagent.jar"
      then
        table.insert(bundles, jar)
      end
    end

    local jdk = vim.env.JAVA_HOME or vim.fn.expand("~/.local/lib/jdks/jdk-21.0.13.1+2")

    vim.lsp.config("jdtls", {
      init_options = {
        bundles = bundles,
        extendedClientCapabilities = jdtls.extendedClientCapabilities,
      },
      settings = {
        java = {
          autobuild = { enabled = true },
          configuration = {
            runtimes = {
              { name = "JavaSE-21", path = jdk, default = true },
            },
          },
          contentProvider = { preferred = true },
          format = { enabled = false }, -- google-java-format via conform.nvim
          imports = { organizeImports = true },
          saveActions = { organizeImports = true },
          signatureHelp = { enabled = true },
        },
      },
    })

    vim.lsp.enable("jdtls")

    local ok, jdtls_dap = pcall(require, "jdtls.dap")
    if ok then
      jdtls_dap.setup_dap({ hotcodereplace = "auto" })
    end
  end,
  keys = {
    { "<leader>jo", function() require("jdtls").organize_imports() end, desc = "Java: organize imports" },
    { "<leader>jt", function() require("jdtls").test_class() end, desc = "Java: test current class" },
    { "<leader>jn", function() require("jdtls").test_nearest_method() end, desc = "Java: test nearest method" },
    { "<leader>jc", function() require("jdtls").compile("full") end, desc = "Java: compile project" },
    { "<leader>jr", function() vim.cmd("JdtRestart") end, desc = "Java: restart language server" },
  },
}
