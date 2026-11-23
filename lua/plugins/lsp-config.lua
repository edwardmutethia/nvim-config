-- nvim-lspconfig server names (mason-lspconfig maps these to Mason packages).
local ensure_installed = {
  "lua_ls",
  "rust_analyzer",
  "pyright",
  "gopls",
  "ts_ls",
  "html",
  "cssls",
  "jsonls",
  "emmet_language_server",
  -- `sqlls` is Node-based and crashes on Node 26 (ERR_PACKAGE_PATH_NOT_EXPORTED);
  -- `sqls` is a self-contained Go server.
  "sqls",
  "clangd",
  "jdtls",
  "eslint",
}

-- rustaceanvim owns rust-analyzer and java.lua owns jdtls, so neither is
-- enabled here. eslint-lsp only attaches in projects that have eslint config.
local enabled_servers = {
  "lua_ls",
  "pyright",
  "gopls",
  "ts_ls",
  "html",
  "cssls",
  "jsonls",
  "emmet_language_server",
  "sqls",
  "clangd",
  "eslint",
}

return {
  {
    "mason-org/mason.nvim",
    lazy = false,
    opts = { ui = { border = "rounded" } },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    lazy = false,
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = ensure_installed,
      -- We enable only the servers we explicitly manage below.
      automatic_enable = false,
    },
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities(
        vim.lsp.protocol.make_client_capabilities()
      )
      vim.lsp.config("*", { capabilities = capabilities })

      -- Breadcrumbs are intentionally disabled for a minimal UI.

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      })

      vim.lsp.config("pyright", {
        settings = {
          pyright = { disableTaggedHints = true },
          python = { analysis = { autoSearchPaths = true, useLibraryCodeForTypes = true } },
        },
      })

      vim.lsp.config("gopls", {
        -- `gotmpl` is not a registered Neovim filetype; keep the config to
        -- recognized Go filetypes so :checkhealth stays clean.
        filetypes = { "go", "gomod", "gowork" },
        settings = {
          gopls = {
            semanticTokens = true,
            -- gopls v0.24 rejects the legacy `ui.completion.usePlaceholders`
            -- nested key; the setting is now top-level.
            usePlaceholders = true,
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
          },
        },
      })

      vim.lsp.config("ts_ls", {
        init_options = { hostInfo = "neovim" },
        settings = {
          javascript = {
            format = { enable = false }, -- Prettier owns formatting.
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
          typescript = {
            format = { enable = false }, -- Prettier owns formatting.
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
        },
      })

      -- Prettier owns formatting for web files; these servers only lint/complete.
      vim.lsp.config("html", {
        init_options = {
          provideFormatter = false,
          embeddedLanguages = { css = true, javascript = true },
          configurationSection = { "html", "css", "javascript" },
        },
      })

      vim.lsp.config("cssls", {
        init_options = { provideFormatter = false },
        settings = {
          css = { validate = true },
          scss = { validate = true },
          less = { validate = true },
        },
      })

      vim.lsp.config("sqls", {
        root_markers = { ".sqllsrc.json", "package.json", ".git" },
      })

      vim.lsp.config("clangd", {
        -- lspconfig advertises c.doxygen/cpp.doxygen, which are not real
        -- Neovim filetypes and produce checkhealth warnings.
        filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
        -- lspconfig still advertises the legacy `offsetEncoding` capability,
        -- which clangd 23 logs as deprecated. Neovim already sends the standard
        -- `general.positionEncodings` capability, so strip the old one before
        -- the initialize request goes out.
        before_init = function(params)
          params.capabilities.offsetEncoding = nil
        end,
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--completion-style=detailed",
          "--header-insertion=never",
          "--fallback-style=WebKit",
        },
      })

      vim.lsp.enable(enabled_servers)

      vim.diagnostic.config({
        virtual_text = { spacing = 2, prefix = "●" },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "✖",
            [vim.diagnostic.severity.WARN] = "▲",
            [vim.diagnostic.severity.INFO] = "ℹ",
            [vim.diagnostic.severity.HINT] = "›",
          },
        },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = { border = "rounded", source = "if_many" },
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp_attach", { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then
            return
          end

          local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = args.buf, silent = true, desc = desc })
          end

          map("n", "K", vim.lsp.buf.hover, "Hover documentation")
          map("n", "gd", vim.lsp.buf.definition, "Go to definition")
          map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
          map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
          -- `grr` is Neovim's built-in references mapping; don't shadow its
          -- `gr*` family (gra/grn/gri/grt/grx) with a prefix mapping.
          map("n", "<C-k>", vim.lsp.buf.signature_help, "Signature help")
          map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("n", "<leader>cr", vim.lsp.buf.rename, "Rename symbol")
          map("n", "<leader>cR", vim.lsp.buf.references, "List references")
          map("n", "<leader>cT", vim.lsp.buf.type_definition, "Go to type definition")
          map("n", "<leader>cl", vim.lsp.codelens.run, "Run code lens")
          map("n", "<leader>ci", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
          end, "Toggle inlay hints")

          if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
          end
          if client.server_capabilities.codeLensProvider then
            vim.lsp.codelens.enable(true, { bufnr = args.buf })
          end
        end,
      })
    end,
  },
}
