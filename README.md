# Neovim IDE setup

Neovim 0.12+ configuration managed by [lazy.nvim](https://github.com/folke/lazy.nvim).
Focused on Lua and Rust, with a complete editing/LSP/debug workflow.

## What is included

- **LSP**: `lua_ls`, `rust_analyzer` (clippy), installed via Mason
- **Completion**: nvim-cmp + LuaSnip + friendly snippets
- **Formatting**: conform.nvim with StyLua / rustfmt / shfmt / jq, format-on-save
- **Linting**: selene for Lua via nvim-lint; clippy through rust-analyzer
- **Debugging**: nvim-dap + DAP UI + virtual text, codelldb for Rust, osv for Lua
- **Navigation**: Telescope (+ fzf native), Neo-tree, Flash, Aerial outline, Trouble
- **Git**: gitsigns and lazygit (floating terminal)
- **UI**: Catppuccin, Lualine, which-key, dressing, notifications, sessions

## Keymaps

Press `<leader>` (Space) to see the which-key menu. The main ones:

| Keys | Action |
| --- | --- |
| `<C-p>` / `<leader>ff` | Find files |
| `<leader>fg` / `<leader>fc` | Live grep / grep word under cursor |
| `<C-n>` | Toggle Neo-tree |
| `<leader>o` | Toggle symbol outline |
| `<leader>xx` / `<leader>xX` | Workspace / buffer diagnostics |
| `K`, `gd`, `gr`, `<leader>ca`, `<leader>cr` | Hover, definition, references, code action, rename |
| `[d` / `]d` | Previous / next diagnostic |
| `<leader>cf` | Format buffer |
| `<F5>` / `<F9>` / `<F10>` / `<F11>` | Continue / breakpoint / step over / step into |
| `<leader>du` | Toggle debug UI |
| `<leader>dl` | Launch Lua debug server (osv) |
| `<leader>gg` | Lazygit |
| `]h` / `[h` / `<leader>hs` | Next hunk / previous hunk / stage hunk |
| `<leader>ss` / `<leader>sl` | Save / restore session |
| `<leader>tt` / `<C-\>` | Floating / default terminal |

## Setup notes

- Plugins and tools are installed automatically. Check with `:Lazy` and `:Mason`.
- `ripgrep` is not installed on this machine. `bin/vimgrep` is used as a
  drop-in fallback for Telescope's live grep. Install ripgrep with
  `sudo dnf install ripgrep` for the full experience (the config detects it
  automatically).
- To debug Lua code: run `<leader>dl` in the Neovim instance running the code,
  open the source in another Neovim instance, set a breakpoint with `<F9>`, and
  press `<F5>` to attach.
- Rust debugging uses codelldb from Mason; build your binary with debug symbols
  first, then `<F5>` prompts for the executable path.
- Run `:checkhealth` after changes to diagnose issues.
