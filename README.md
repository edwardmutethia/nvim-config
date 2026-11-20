# Development Environment Guide

A minimal, Catppuccin-themed setup for **Neovim**, **tmux**, and the **Zsh/Starship
prompt**. Everything is configured locally (no sudo) and tuned for polyglot
development: Lua, Rust, Python, Go, TypeScript/JavaScript, React, HTML, CSS, C,
C++, Java, and SQL.

## Where things live

| File | What it controls |
| --- | --- |
| `~/.config/nvim/` | Neovim config (this directory) |
| `tmux.conf` (symlinked to `~/.tmux.conf`) | tmux prefix, splits, windows, copy mode, status line |
| `~/.config/starship.toml` | Prompt (Starship) |
| `~/.zshrc` | Shell behavior, history, completion, `JAVA_HOME`/`PATH` |

After changing a config, reload it as shown below. No changes are committed
automatically.

---

# 1. Neovim

Neovim 0.12+ with plugins managed by [lazy.nvim](https://github.com/folke/lazy.nvim).

## Getting started

1. Open any file: `nvim path/to/file`.
2. `<leader>` is **Space**. Press it and wait to see the which-key menu of
   available actions.
3. Press `?` to list every mapping.

The UI is intentionally quiet: a single status line (mode, filename,
diagnostics, cursor position), no breadcrumb bar, no always-on sign column, and
a faint current-line highlight.

## Everyday editing

| Keys | Action |
| --- | --- |
| `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>` | Move focus between splits |
| `<C-Up>` / `<C-Down>` | Grow / shrink window height |
| `<C-Left>` / `<C-Right>` | Shrink / grow window width |
| `<Tab>` / `<S-Tab>` | Next / previous buffer |
| `<leader>ws` / `<leader>wq` / `<leader>wQ` | Save / close / force-close buffer |
| `v` then `J` / `K` | Move selection down / up |
| `v` then `<` / `>` | Outdent / indent selection |
| `[` / `]` | Add blank line above / below |
| `n` / `N` | Next / previous search result, centered |
| `<leader>uh` | Clear search highlighting |
| `<leader>uw` | Toggle line wrap |
| `s` / `S` | Flash jump / Flash treesitter jump |

## Code navigation and LSP

These mappings appear when a language server attaches to the buffer.

| Keys | Action |
| --- | --- |
| `K` | Hover documentation |
| `gd` / `gD` / `gi` | Definition / declaration / implementation |
| `<C-k>` | Signature help |
| `grr` or `<leader>cR` | List references |
| `gra` / `<leader>ca` | Code action |
| `grn` / `<leader>cr` | Rename symbol |
| `gri` / `grt` | Implementation / type definition |
| `grx` / `<leader>cl` | Run code lens |
| `<leader>ci` | Toggle inlay hints |
| `<leader>cs` | Document symbols |
| `<leader>o` | Toggle symbol outline |
| `[d` / `]d` | Previous / next diagnostic |
| `<C-w>d` | Show diagnostics under cursor |

## Find, grep, and files (Telescope)

| Keys | Action |
| --- | --- |
| `<C-p>` / `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fc` | Grep word under cursor |
| `<leader>fb` | Find open buffers |
| `<leader>fr` | Recent files |
| `<leader>fh` / `<leader>fk` | Search help / search keymaps |

In Telescope: `<C-j>`/`<C-k>` move, `<Enter>` selects, `<Esc>` closes.

## Files, diagnostics, git

| Keys | Action |
| --- | --- |
| `<C-n>` / `<leader>en` | Toggle Neo-tree file explorer |
| `<leader>eb` / `<leader>eg` | Toggle buffer list / git status panel |
| `<leader>xx` / `<leader>xX` | Workspace / buffer diagnostics |
| `<leader>xq` | Quickfix list |
| `<leader>gd` / `<leader>gf` / `<leader>gc` | Git branch diff / file history / close diff |
| `<leader>gg` | Lazygit in a floating terminal |
| `]h` / `[h` / `<leader>hs` | Next hunk / previous hunk / stage hunk |

In Neo-tree: `q` or `<C-n>` closes, Enter opens a file.

## Formatting and linting

- Formatting runs on save via conform.nvim. Use `<leader>cf` to format manually.
- Diagnostics come from the LSP plus linters; browse with `[d` / `]d` or open the
  list with `<leader>xx`.
- Each language uses its native toolchain (see *What is included* below).

## Testing (neotest)

| Keys | Action |
| --- | --- |
| `<leader>nt` / `<leader>nf` / `<leader>na` | Nearest test / test file / all tests |
| `<leader>nb` / `<leader>nl` | Debug nearest test / rerun last test |
| `<leader>ns` / `<leader>no` / `<leader>nS` | Summary / output / stop |

## Debugging (nvim-dap)

| Keys | Action |
| --- | --- |
| `<F5>` / `<F6>` | Continue / pause |
| `<F9>` | Toggle breakpoint |
| `<F10>` / `<F11>` / `<F12>` | Step over / step into / step out |
| `<leader>du` / `<leader>dr` / `<leader>dw` | Toggle debug UI / REPL / hover value |
| `<leader>dl` | Launch Lua debug server (osv) |

## Java and Rust extras

| Keys | Action |
| --- | --- |
| `<leader>jo` / `<leader>jc` / `<leader>jr` | Java organize imports / compile / restart LSP |
| `<leader>jt` / `<leader>jn` | Java test class / nearest test method |
| `<leader>rr` / `<leader>rd` / `<leader>rt` | Rust runnables / debuggables / testables |
| `<leader>rT` / `<leader>rh` / `<leader>rE` | Related tests / hover actions / explain error |

## Terminal and sessions

| Keys | Action |
| --- | --- |
| `<leader>tt` | Floating terminal |
| `<C-\>` / `<C-Bslash>` | Default terminal |
| `<leader>ss` / `<leader>sr` | Save / restore session |
| `<leader>sl` / `<leader>sx` | Restore last session / stop session tracking |

## What is included

- **LSP**: `lua_ls`, `pyright`, `gopls`, `ts_ls`, `html`, `cssls`, `jsonls`,
  `emmet_language_server`, `sqlls`, `clangd`, `eslint`. `rust_analyzer` is owned
  by rustaceanvim; `jdtls` by nvim-jdtls (with a JavaSE-21 runtime).
- **Completion**: nvim-cmp + LuaSnip + friendly snippets.
- **Formatting** (format-on-save): StyLua, rustfmt, `ruff_fix` + `ruff_format`,
  gofumpt, Prettier, clang-format, google-java-format, sqlfluff, shfmt.
- **Linting**: selene, clippy, ruff, golangci-lint, eslint-lsp, htmlhint,
  stylelint, clang-tidy, checkstyle, sqlfluff.
- **Testing**: neotest with rustaceanvim, plenary, python, go, vitest, jest,
  java, gtest, and ctest adapters.
- **Debugging**: codelldb, debugpy, delve, js-debug-adapter, jdtls adapter, osv.
- **Navigation**: Telescope (fzf-native), Neo-tree, Flash, Aerial, Trouble,
  diffview.nvim.
- **UI**: Catppuccin, Lualine, which-key, dressing, notifications, sessions.
- **Git**: gitsigns, diffview.nvim, lazygit.

## Neovim setup notes

- Plugins and Mason tools install automatically. Inspect with `:Lazy` and
  `:Mason`. Servers are enabled explicitly in `lua/plugins/lsp-config.lua`
  (`mason-lspconfig.automatic_enable = false`).
- Do not add duplicate nvim-lspconfig setups for `rust_analyzer` or `jdtls`.
- Java uses `nvim-jdtls` with `java-debug-adapter` and `java-test`; do not add
  `nvim-java`. A local Temurin JDK 21 is set through `JAVA_HOME`/`PATH` in
  `lua/options.lua`.
- The JUnit jar for neotest-java is already downloaded. Re-run `:NeotestJava
  setup` if it is removed.
- Rust tests use cargo-nextest with a `cargo test` fallback; Lua uses `busted`;
  Python uses `pytest` (install in the project venv when needed).
- JS/TS/React linting needs a project ESLint config. Prettier, Vitest, Jest and
  project npm packages are installed per project, not globally.
- C/C++ prefers a `compile_commands.json`; CMake projects can use the ctest
  adapter. SQL uses `sqlls` + `sqlfluff` (add `.sqlfluff` for project rules).
- Remote providers (Node/Python/Perl/Ruby) are disabled. `:checkhealth` shows
  only harmless warnings for optional runtimes.

---

# 2. tmux

tmux keeps sessions, windows, and panes organized. The prefix key is **Ctrl+A**
(repeat it to send a literal Ctrl+A to the program).

Reload after editing:

```sh
tmux source-file ~/.tmux.conf
```

Start a session:

```sh
tmux new -s work
```

## Sessions

| Key | Action |
| --- | --- |
| `<prefix> d` | Detach from the current session |
| `tmux ls` | List sessions |
| `tmux attach -t work` | Reattach to a session |
| `<prefix> $` | Rename the current session |
| `<prefix> r` | Reload the config |

## Windows

Windows are numbered from 1.

| Key | Action |
| --- | --- |
| `<prefix> c` | New window in the current directory |
| `<M-1>` … `<M-5>` | Jump to window 1–5 (no prefix) |
| `<prefix> n` / `<prefix> p` | Next / previous window |
| `<prefix> ,` | Rename the current window |

## Panes

| Key | Action |
| --- | --- |
| `<prefix> \|` | Split vertically (new pane on the right) |
| `<prefix> -` | Split horizontally (new pane below) |
| `<prefix> %` / `<prefix> "` | Same splits, preserving the current directory |
| `<M-Left/Right/Up/Down>` | Move between panes (no prefix) |
| `<C-Left/Right/Up/Down>` | Resize panes by 5 cells (no prefix) |
| `<prefix> z` | Zoom / unzoom the current pane |
| `<prefix> x` | Close the current pane |

Mouse support is on: click to focus, drag borders to resize, scroll to browse.

## Copy mode

| Key | Action |
| --- | --- |
| `<prefix> [` | Enter copy mode |
| `v` | Begin selection |
| `V` | Select the whole line |
| `y` or `<Enter>` | Copy selection to the system clipboard and exit |
| `<Esc>` | Cancel |

`k`/`j` and arrows scroll; `/` searches. The status bar is minimal: just the
session name on the left and window names in the middle, with the active window
slightly brighter. No clock or date.

---

# 3. Prompt (Starship + Zsh)

The prompt is deliberately minimal — two lines:

```text
~/projects/myapp
❯
```

- Top line: **only the current directory name** (`~` at home).
- Bottom line: a colored `❯`:
  - **green** after a successful command
  - **red** after a failed command
  - **blue `❮`** in Zsh vi-command mode

Colors follow Catppuccin Mocha. No git status pile, language versions, icons,
time, or command duration.

Zsh also exports the local Temurin JDK as `JAVA_HOME` and prepends it to `PATH`,
so `java`, `javac`, and Java tooling work in the terminal as well as in Neovim.

Reload after editing:

```sh
exec zsh
```

Starship is initialized from `~/.zshrc`; if the prompt ever disappears, ensure
that file still contains `eval "$(starship init zsh)"`.

---

# 4. Maintenance

```sh
nvim +Lazy check      # plugin updates (inside Neovim: :Lazy check)
nvim +checkhealth     # health report (inside Neovim: :checkhealth)
:Mason                # manage LSP/DAP/formatter binaries
```

Common fixes:

- **LSP not starting**: open `:Mason` and confirm the server is installed, then
  restart Neovim.
- **Formatter missing**: install the tool with `:Mason` (or your package manager).
- **JS/TS diagnostics missing**: add an `eslint.config.mjs` (or legacy config) to
  the project.
- **Icons look wrong**: set your terminal font to **JetBrainsMono Nerd Font**.
- **tmux colors look flat**: ensure `TERM=tmux-256color` inside tmux and truecolor
  enabled in the terminal; the config sets RGB overrides automatically.
