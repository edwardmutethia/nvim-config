local has_rg = vim.fn.executable("rg") == 1

-- Prefer the LSP's project-wide symbol index. Fall back to live grep in files
-- where no attached language server provides workspace symbols.
local function workspace_symbols()
  local builtin = require("telescope.builtin")
  local has_symbols = false
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    if client.server_capabilities.workspaceSymbolProvider then
      has_symbols = true
      break
    end
  end

  if has_symbols then
    builtin.lsp_dynamic_workspace_symbols()
  else
    builtin.live_grep()
  end
end

return {
  "nvim-telescope/telescope.nvim",
  branch = "master",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },
  },
  keys = {
    { "<C-p>", "<cmd>Telescope find_files<CR>", desc = "Find files" },
    { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
    { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Live grep" },
    { "<leader>fc", "<cmd>Telescope grep_string<CR>", desc = "Grep word under cursor" },
    { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Find buffers" },
    { "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Recent files" },
    { "<leader>fs", workspace_symbols, desc = "Find symbol in project" },
    { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Search help" },
    { "<leader>fk", "<cmd>Telescope keymaps<CR>", desc = "Search keymaps" },
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        prompt_prefix = " 󰫎 ",
        selection_caret = " ❯ ",
        file_ignore_patterns = { "%.git/", "node_modules/", "target/", "%.lazy/", "%.local/" },
        layout_config = { width = 0.9, height = 0.8, preview_width = 0.5 },
        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
          },
          n = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
          },
        },
        vimgrep_arguments = has_rg
            and {
              "rg",
              "--color=never",
              "--no-heading",
              "--with-filename",
              "--line-number",
              "--column",
              "--smart-case",
            }
          or { vim.fn.stdpath("config") .. "/bin/vimgrep" },
      },
      extensions = { fzf = {} },
    })

    pcall(telescope.load_extension, "fzf")
  end,
}
