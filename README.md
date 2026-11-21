# Developer Environment Bootcamp

### Neovim · tmux · Zsh/Starship

This is a **hands-on course** for the local development environment on this
machine. Read Part I once from top to bottom with Neovim open, do the small
exercises, then use Part IV as your everyday cheat sheet.

Everything is installed locally (no sudo) and tuned for polyglot work: Lua,
Rust, Python, Go, TypeScript/JavaScript, React, HTML, CSS, C, C++, Java, and SQL.

---

## How to use this guide

- Each lesson has a **Goal**, a **Learn** table, a **Try it** drill, and a
  **Checkpoint**. Do not skip the drills; muscle memory is the point.
- `<leader>` means **Space**. `<localleader>` means **`\`** (backslash).
- Press **Space** and wait ~400 ms: which-key shows the available chords.
- `<leader>?` opens the full which-key keymap browser. For a searchable list,
  use `<leader>fk`.
- Tags in the tables:
  - **[CFG]** — explicitly configured in this repo.
  - **[PLUGIN]** — default from an installed plugin, active because the config
    loads that plugin.
  - **[VIM]** — built-in Neovim/Vim behavior, deliberately preserved.
- `n` = Normal, `i` = Insert, `v` = Visual, `x` = Visual Line/Block, `o` =
  Operator-pending, `t` = Terminal, `c` = Command-line.

### Where things live

| File | What it controls |
| --- | --- |
| `~/.config/nvim/` | Neovim config (this directory) |
| `tmux.conf` (symlinked to `~/.tmux.conf`) | tmux prefix, splits, windows, copy mode, status line |
| `alacritty.toml` (symlinked to `~/.config/alacritty/alacritty.toml`) | Terminal colors, font, and 90×25 startup size |
| `~/.config/starship.toml` | Prompt |
| `~/.zshrc` | Shell behavior, history, completion, `JAVA_HOME`/`PATH` |

After changing a config, restart Neovim. For plugin changes also run
`:Lazy install` / `:Lazy check` inside Neovim.

## Latest additions

- **GNOME Adwaita Dark in Alacritty** — terminal palette derived from the dark
  title bar/headerbar colors, so the whole window looks like one surface;
  Neovim's transparent Catppuccin Mocha blends into it.
- **Catppuccin Mocha, transparent** — Neovim uses the Mocha palette but leaves
  the background to the terminal, so it blends with any terminal theme.
- `<leader>fs` — project-wide symbol search (LSP, with ripgrep fallback).
- `<leader>bb` / `<leader>bt` / `<leader>br` / `<leader>bo` — smart builds and
  task management with quickfix errors.
- `<leader>fR` / `<leader>fF` — previewed project/file replacement.
- `<leader>wq` / `<leader>wQ` — buffer close that preserves splits.
- `<leader>mp` — rendered Markdown preview toggle, including README auto-preview
  in Neo-tree.
- Four-space indentation is enforced after filetype detection and after
  format-on-save.
- `<C-o>` / `<C-i>` — jump back / forward after `gd` and other jumps.

---

# PART I — Neovim Class

## Lesson 1 — Orientation: modes, leader, and which-key

**Goal:** Stop guessing which key does what. Learn to ask the editor.

Neovim is modal. The same key means different things in different modes:

| Mode | Enter it with | Leave it with |
| --- | --- | --- |
| Normal | `<Esc>` from anywhere | — (this is “home”) |
| Insert | `i`, `a`, `o`, `c{motion}` | `<Esc>` |
| Visual | `v`, `V`, `<C-v>` | `<Esc>` or `v` |
| Command | `:` | `<Enter>` or `<Esc>` |
| Terminal | `<C-\>` in Normal | `<C-\><C-n>` |

### Learn

| Keys | Action | Tag |
| --- | --- | --- |
| `<leader>` = `Space` | Prefix for almost every custom command | [CFG] |
| `<localleader>` = `\` | Prefix used inside grug-far buffers | [CFG] |
| `<leader>?` | Open the full which-key browser | [CFG] |
| `Space`, wait | Open the which-key menu for a group | [CFG] |
| `q` | Close helper windows (help, quickfix, checkhealth, lspinfo, man, notify, Trouble) | [CFG] |
| `timeoutlen = 400` | How long which-key waits before showing hints | [CFG] |

The configured which-key groups are:

| Prefix | Group | Prefix | Group |
| --- | --- | --- | --- |
| `<leader>b` | build / tasks | `<leader>n` | test |
| `<leader>c` | code | `<leader>r` | rust / run |
| `<leader>d` | debug | `<leader>s` | session |
| `<leader>e` | explorer | `<leader>t` | terminal / toggle |
| `<leader>f` | find | `<leader>u` | ui |
| `<leader>g` | git | `<leader>w` | buffer / write |
| `<leader>h` | hunks | `<leader>x` | diagnostics |
| `<leader>j` | java | `<leader>m` | markdown |

### Try it

1. Open this file: `nvim ~/.config/nvim/README.md`.
2. Press `Space` and release. Wait for the menu.
3. Press `b`, then `?`-browse with the menu; press `<Esc>` to cancel.
4. Press `<leader>?` to see the full browser, then `q` to close it.
5. Press `<leader>fk` and type `build` in Telescope to search mappings.

### Checkpoint

You can find any mapping without memorizing it. That is the real shortcut.

> Correction: plain `?` is still Vim’s “search backwards” command. The keymap
> browser is **`<leader>?`**, not `?`.

---

## Lesson 2 — Motions: think in verbs and nouns

**Goal:** Move without arrow keys and edit whole ideas, not single characters.

Vim language is:

```text
operator + motion/text-object
```

Examples: `diw` = **d**elete **i**nner **w**ord; `cap` = **c**hange **a**
**p**aragraph; `yip` = **y**ank **i**nner paragraph.

### Learn — built-in motions [VIM]

| Keys | Move to |
| --- | --- |
| `h` `j` `k` `l` | Left / down / up / right |
| `w` / `b` / `e` | Next word / previous word / end of word |
| `W` / `B` / `E` | Same, ignoring punctuation |
| `0` / `^` / `$` | Start of line / first non-blank / end of line |
| `f{c}` / `F{c}` | Forward / backward to character |
| `t{c}` / `T{c}` | Forward / backward *before* character |
| `;` / `,` | Repeat / reverse last `f`/`t` search |
| `gg` / `G` | First / last line |
| `{` / `}` | Previous / next blank-line paragraph |
| `<C-d>` / `<C-u>` | Half page down / up |
| `H` / `M` / `L` | Top / middle / bottom of screen |
| `%` | Matching bracket/parenthesis |
| `*` / `#` | Search word under cursor forward / backward |
| `n` / `N` | Next / previous search result, **centered** [CFG] |

### Learn — text objects [VIM]

| Object | Means |
| --- | --- |
| `iw` / `aw` | inner word / a word (with surrounding space) |
| `i"` / `a"` | inside quotes / quotes included |
| `i(` / `a(` | inside parentheses / parentheses included |
| `i{` / `a{` | inside braces / braces included |
| `ip` / `ap` | inner paragraph / paragraph included |
| `it` / `at` | inner HTML/XML tag / tag included |

### Learn — Flash navigation [CFG/PLUGIN]

| Keys | Action | Tag |
| --- | --- | --- |
| `s` | Flash jump: type characters, watch labels, press the label | [CFG] |
| `S` | Flash treesitter jump: select a syntax node | [CFG] |
| `r` (operator-pending) | Remote flash: jump to another window, then apply operator | [CFG] |
| `R` (visual / operator) | Flash treesitter search | [CFG] |
| `f`/`t`/`F`/`T`, `;`, `,` | Enhanced by Flash character mode | [PLUGIN] |

> Surround note: `ys`/`ds`/`cs` are the reliable surround keys. Visual `S`
> is also claimed by nvim-surround, so use **`gS`** for “surround visual
> selection”. Normal `s` no longer substitutes a character; it is Flash.

### Try it

Open any code file and do this slowly:

1. Put the cursor on a variable. Press `ciw`, type `renamed`, `<Esc>`.
2. Put the cursor inside a string. Press `ci"` and replace its contents.
3. Press `s`, type two letters from a distant word, then the highlighted label.
4. Press `*` to search the word, then `n` three times and notice the centering.
5. Press `<leader>uh` to clear the search highlight.

### Checkpoint

You can rename a word without holding Shift/ arrows, and you can jump across a
screen with two keystrokes.

---

## Lesson 3 — Editing at speed: operators, repeat, visual mode

**Goal:** Edit once, repeat intelligently, and let plugins handle structure.

### Learn — operators and repeat [VIM/CFG]

| Keys | Action | Tag |
| --- | --- | --- |
| `d{motion}` / `c{motion}` / `y{motion}` | Delete / change / yank region | [VIM] |
| `dd` / `cc` / `yy` | Same, linewise | [VIM] |
| `p` / `P` | Paste after / before cursor | [VIM] |
| `u` / `<C-r>` | Undo / redo | [VIM] |
| `.` | Repeat the last change | [VIM] |
| `x` / `~` | Delete char / toggle case | [VIM] |
| `gc{motion}` / `gcc` | Toggle comment [CFG label + plugin default] | [PLUGIN] |
| `gb` / `gbc` | Block comment / block comment line | [PLUGIN] |
| `gco` / `gcO` / `gcA` | Comment below / above / end of line | [PLUGIN] |
| `gq{motion}` | Format a motion with conform.nvim | [CFG] |
| `<leader>cf` | Format the whole buffer (Normal + Visual) | [CFG] |
| `ys{motion}{char}` / `yss{char}` | Add surround / surround whole line | [PLUGIN] |
| `ds{char}` / `cs{a}{b}` | Delete / change surround | [PLUGIN] |
| `gS` (Visual) | Surround the selection | [PLUGIN] |
| `<C-g>s` / `<C-g>S` (Insert) | Surround from insert mode | [PLUGIN] |

### Learn — Visual mode

| Keys | Action | Tag |
| --- | --- | --- |
| `v` / `V` / `<C-v>` | Character / line / block Visual | [VIM] |
| `o` (in Visual) | Jump to the other end of the selection | [VIM] |
| `v` then `J` / `K` | Move selection down / up, reindent, reselect | [CFG] |
| `v` then `<` / `>` | Outdent / indent, keep selection | [CFG] |
| `v` then `S` / `gS` | Flash treesitter / surround selection — see conflict note | [CFG/PLUGIN] |

### Indentation is locked to four spaces

| Setting | Value |
| --- | --- |
| `expandtab` | on (Tab inserts spaces) |
| `tabstop` | 4 |
| `softtabstop` | 4 |
| `shiftwidth` | 4 |

These are re-applied after every `FileType` event, so filetype plugins such as
Go’s cannot silently switch you back to tabs. Format-on-save also respects
this: clang-format, Prettier, StyLua, rustfmt, Ruff, google-java-format, and
gofumpt are all given four-space settings (gofumpt emits tabs, so a small
post-formatter converts only leading indentation back to spaces).

> Exception: `Makefile` recipes must begin with a real tab or `make` fails.
> They still display at four columns, but the underlying tab is preserved.

### Learn — Insert mode & completion

| Keys | Action | Tag |
| --- | --- | --- |
| `<Tab>` (Insert/Snippet) | Next completion → expand/jump snippet → invoke completion → fallback | [CFG] |
| `<S-Tab>` (Insert/Snippet) | Previous item / previous snippet stop | [CFG] |
| `<C-Space>` | Trigger completion | [CFG] |
| `<CR>` | Confirm completion | [CFG] |
| `<C-e>` | Abort completion | [CFG] |
| `<C-b>` / `<C-f>` | Scroll completion docs up / down | [CFG] |
| `<Down>` / `<Up>` | Select next / previous item | [PLUGIN] |
| `<C-n>` / `<C-p>` | Next / previous item or open completion | [PLUGIN] |
| `<C-y>` | Confirm without selecting | [PLUGIN] |

> In **Normal** mode `<Tab>` / `<S-Tab>` mean next / previous buffer. In
> **Insert** mode they mean completion / snippet navigation. Same keys,
> different modes — that is intentional.

### Try it

1. Put the cursor on `foo`. Press `ciw`, type `bar`, `<Esc>`.
2. Move to another `foo` and press `.` — the change repeats.
3. Select three lines with `V`, press `J` twice, then `>` once.
4. Wrap a word in parentheses: cursor on it, `ysiw(`. Remove them with `ds(`.
5. Comment a line with `gcc`; comment a motion with `gcip`.

### Checkpoint

You can make a change, repeat it, move lines, and add/remove structure without
leaving the keyboard.

---

## Lesson 4 — Buffers, windows, and layout control

**Goal:** Move around the editor without destroying your carefully built layout.

- **Buffer** = a file loaded into memory.
- **Window** = a viewport showing a buffer.
- **Tab page** = a collection of windows (rarely needed here).

### Learn

| Keys | Action | Tag |
| --- | --- | --- |
| `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>` | Focus left / lower / upper / right window | [CFG] |
| `<C-Up>` / `<C-Down>` | Grow / shrink window height | [CFG] |
| `<C-Left>` / `<C-Right>` | Shrink / grow window width | [CFG] |
| `<Tab>` / `<S-Tab>` | Next / previous buffer | [CFG] |
| `<C-o>` / `<C-i>` | Jump back / forward to previous cursor positions | [VIM] |
| `<leader>ws` | Save buffer | [CFG] |
| `<leader>wq` | Close buffer, **keep window layout** | [CFG] |
| `<leader>wQ` | Force-close buffer, **keep window layout** | [CFG] |
| `q` | Close helper windows | [CFG] |

`wq`/`wQ` use `mini.bufremove`; unlike plain `:bdelete`, they will not collapse
your splits when the closed buffer was visible in more than one window.

### Try it

1. Open two files, then create a split with `<C-w>v` [VIM].
2. Move focus with `<C-h>` / `<C-l>`.
3. Resize with `<C-Left>` / `<C-Right>`.
4. In one window press `<leader>wq`; the window should remain with another buffer.

### Checkpoint

You can close files without losing your workspace geometry.

---

## Lesson 5 — Find anything, replace safely

**Goal:** Never manually hunt through a repo again.

### Learn — Telescope [CFG]

| Keys | Action |
| --- | --- |
| `<C-p>` / `<leader>ff` | Find files |
| `<leader>fg` | Live grep (ripgrep) across the project |
| `<leader>fc` | Grep the word under the cursor |
| `<leader>fb` | Find open buffers |
| `<leader>fr` | Recent files |
| `<leader>fs` | Find symbol in project (LSP workspace symbols, ripgrep fallback) |
| `<leader>fh` | Search help tags |
| `<leader>fk` | Search keymaps (same list as `<leader>?`) |
| `<C-j>` / `<C-k>` | Next / previous result in the prompt |
| `<C-q>` | Send results to the quickfix list and open it |
| `<CR>` | Select current result |
| `<Esc>` | Close Telescope |

### Learn — grug-far search & replace [CFG/PLUGIN]

| Keys | Action | Tag |
| --- | --- | --- |
| `<leader>fR` | Replace word under cursor across project | [CFG] |
| Visual, then `<leader>fR` | Replace selected text across project | [CFG] |
| `<leader>fF` | Replace in the current file only | [CFG] |
| `<Tab>` / `<S-Tab>` | Next / previous input field in grug-far | [PLUGIN] |
| `\r` (`<localleader>r`) | Apply the replacement | [PLUGIN] |
| `\c` | Close grug-far | [PLUGIN] |
| `<CR>` | Jump to result under cursor | [PLUGIN] |
| `\o`, `\<down>`, `\<up>` | Open location / next / previous location | [PLUGIN] |
| `\q`, `\s`, `\l`, `\f`, `\t`, `\a`, `\b` | Quickfix / sync locations / sync line / refresh / history open / history add / abort | [PLUGIN] |
| `\i`, `\w`, `\e`, `\x`, `\j`, `\k`, `\n`, `\p`, `\v` | Preview / toggle command / swap engine / swap interpreter / apply next+prev / sync next+prev / sync file | [PLUGIN] |
| `g?` | Show grug-far help | [PLUGIN] |

Recall `<localleader>` is `\`, so `\r` means “backslash then r”.

### Try it

1. Put the cursor on a variable name and press `<leader>fc`. Confirm the
   references list.
2. Press `<Esc>`, then `<leader>fR`. The search field is pre-filled.
3. `<Tab>` to the replacement field, type the new name, then press `\r`.
4. Review the diff in the result list; `<CR>` jumps to a match; `\c` closes.

### Checkpoint

You can answer “where is this used?” and “change them all” in under ten keys,
with a preview before anything is written.

---

## Lesson 6 — Code intelligence: LSP, diagnostics, symbols

**Goal:** Let the language server answer questions instead of you guessing.

These mappings appear when a language server attaches. Both the `gr*` family and
`<C-w>d` are Neovim 0.11+ built-ins that this config deliberately preserves.

### Learn — LSP navigation [CFG/VIM]

| Keys | Action | Tag |
| --- | --- | --- |
| `K` | Hover documentation | [CFG] |
| `gd` / `gD` / `gi` | Definition / declaration / implementation | [CFG] |
| `<C-k>` | Signature help (overrides window-left in language buffers) | [CFG] |
| `grr` / `<leader>cR` | List references | [VIM/CFG] |
| `gra` / `<leader>ca` | Code action | [VIM/CFG] |
| `grn` / `<leader>cr` | Rename symbol | [VIM/CFG] |
| `gri` / `grt` | Implementation / type definition | [VIM] |
| `<leader>cT` | Go to type definition | [CFG] |
| `grx` / `<leader>cl` | Run code lens | [VIM/CFG] |
| `<leader>ci` | Toggle inlay hints | [CFG] |
| `<C-w>d` | Show diagnostic under cursor | [VIM] |

### Learn — function descriptions and function lists

| Need | Keys | What you get |
| --- | --- | --- |
| Description / docstring of the function under the cursor | `K` | LSP hover: signature, doc comment, and type info in a floating window |
| Help while typing arguments | `<C-k>` | Signature help with the active parameter highlighted |
| Read the implementation | `gd` | Jump to definition; `<leader>cT` for type definition |
| Return after `gd` / `K` / any jump | `<C-o>` | Jump back to the exact previous cursor position; `<C-i>` goes forward again |
| All functions in the **current file** | `<leader>o` | Aerial outline on the right; functions/methods are already included in its filter |
| Same list as a navigable list | `<leader>cs` | Trouble document symbols for the current buffer |
| All functions in the **project** | `<leader>fs` | Telescope LSP workspace symbols; type a name to filter across files |
| No language server / weak LSP | `<leader>fs` fallback | Ripgrep live grep; search e.g. `function foo`, `def foo`, `fn foo` |

Inside Aerial [PLUGIN]: `?` help, `<CR>` jump to symbol, `p` scroll symbol
preview, `<C-j>`/`<C-k>` move and scroll, `o` fold/unfold, `q` close.

If `K` shows only a signature or nothing at all, that language server does not
expose documentation for that symbol. Confirm the server with `:LspInfo` and
install it through `:Mason` if needed.

### Learn — diagnostics & symbols [CFG]

| Keys | Action |
| --- | --- |
| `[d` / `]d` | Previous / next diagnostic |
| `<leader>xx` / `<leader>xX` | Workspace / buffer diagnostics (Trouble) |
| `<leader>xq` | Quickfix list (Trouble view) |
| `<leader>cs` | Document symbols (Trouble) |
| `<leader>o` | Toggle Aerial symbol outline |

Trouble buffer defaults [PLUGIN]: `?` help, `q`/`<Esc>` close, `<CR>` jump,
`o` jump and close, `[[`/`]]` previous/next, `r`/`R` refresh/auto-refresh.

Aerial buffer defaults [PLUGIN]: `?` help, `<CR>` jump, `p` preview scroll,
`<C-j>`/`<C-k>` move and scroll, `o` fold/unfold, `q` close.

Fidget shows LSP progress in a corner; it has no keys. If the corner spinner is
moving, the server is indexing — not hung.

### Try it

1. Open a source file with an LSP attached (`.py`, `.rs`, `.c`, `.lua`, …).
2. `K` on a function; `<C-k>` inside a call; `gd` to its definition.
3. Press `<C-o>` to come straight back, then `<C-i>` to go forward again.
4. `<leader>cR` to list references; `<leader>cr` to rename everywhere.
5. `]d` three times; `<leader>xx` for the full workspace list; `q` to close.
6. `<leader>o` to toggle the outline; `<CR>` on a symbol to jump.
7. `<leader>fs`, type a function name, and jump to it anywhere in the project.

### Checkpoint

You can navigate and refactor by symbol name, not by line number.

---

## Lesson 7 — The build, test, and fix loop

**Goal:** Turn “save → compile → read error → edit” into a tight keyboard loop.

### Learn — build & tasks [CFG]

| Keys | Action |
| --- | --- |
| `<leader>bb` | Smart build: CMake, Make, Cargo, Go, or npm |
| `<leader>bt` | Toggle the task list |
| `<leader>br` | Restart the last finished task |
| `<leader>bo` | Open the last task output in a float |
| `:Build` | Same as `<leader>bb` |
| `:OverseerRun` | Pick from detected tasks and `.vscode/tasks.json` |

`<leader>bb` detects the project root and uses an existing `build/` tree. If the
CMake cache points at a different directory, the task refreshes it with
`cmake --fresh` before building. Compiler errors go into the quickfix list; on
failure it opens automatically.

Overseer task-list defaults [PLUGIN]: `?` help, `<CR>` run action, `dd`
dispose, `<C-e>` edit, `o`/`<C-v>`/`<C-s>`/`<C-t>`/`<C-f>` open output in
current/vsplit/split/tab/float, `p` preview, `{`/`}` previous/next task.

### Learn — quickfix [VIM/CFG]

| Keys | Action |
| --- | --- |
| `<leader>xq` | Open quickfix via Trouble |
| `:cnext` / `:cprev` | Next / previous error |
| `:cc` | Show current error |
| `:copen` / `:cclose` | Native quickfix window |

### Learn — testing [CFG]

| Keys | Action |
| --- | --- |
| `<leader>nt` / `<leader>nf` / `<leader>na` | Nearest test / test file / all tests |
| `<leader>nb` / `<leader>nl` | Debug nearest test / rerun last test |
| `<leader>ns` / `<leader>no` / `<leader>nS` | Summary / output / stop |

### Learn — formatting & linting [CFG]

- Format-on-save is automatic via conform.nvim.
- `<leader>cf` formats manually; `gq{motion}` formats a region.
- Linting runs on `BufWritePost` / `BufEnter`.
- Diagnostics come from LSP + linters; browse with `[d`/`]d` or `<leader>xx`.

### Try it

In a project with a Makefile or CMakeLists.txt:

1. `<leader>bb`.
2. If it fails, quickfix opens. Use `:cnext` / `:cprev` to visit errors.
3. Fix one error, `<leader>ws` to save, `<leader>br` to rerun.
4. `<leader>nt` for the nearest test, `<leader>no` for output.
5. `<leader>bt`, press `?`, explore, `q` to close.

### Checkpoint

You have a repeatable loop: **build → quickfix → fix → retest**, all without a
mouse.

---

## Lesson 8 — Debugging without leaving Neovim

**Goal:** Set a breakpoint, inspect state, and step confidently.

A project-local `.vscode/launch.json` is read automatically when `<F5>` starts
a session. Built-in configurations are fallbacks when no launch file exists.
Overseer supports `preLaunchTask` / `postDebugTask` when DAP starts.

### Learn

| Keys | Action | Tag |
| --- | --- | --- |
| `<F9>` | Toggle breakpoint | [CFG] |
| `<F5>` / `<F6>` | Continue / pause | [CFG] |
| `<F10>` / `<F11>` / `<F12>` | Step over / step into / step out | [CFG] |
| `<leader>du` | Toggle debug UI | [CFG] |
| `<leader>dr` | Open DAP REPL | [CFG] |
| `<leader>dw` | Hover value under cursor | [CFG] |
| `<leader>dl` | Launch Lua debug server (osv, port 8086) | [CFG] |

DAP UI buffer defaults [PLUGIN]: `<CR>` expand variable; `o` open; `d` remove;
`e` edit; `r` REPL; `t` toggle; `w` watch; `q`/`<Esc>` close a float.

Signs: `●` breakpoint, `◆` conditional/log point, `▶` stopped, `○` rejected.

### Try it

1. Open a C/Python/JS file, put the cursor on a suspicious line, `<F9>`.
2. `<F5>` to continue. If multiple launch configs exist, pick one.
3. `<F10>` over a call, `<F11>` into it, `<F12>` out.
4. `<leader>dw` on a variable; `<leader>dr` to poke values in the REPL.
5. `<F5>` to finish; `<leader>du` if you want to hide the UI.

### Checkpoint

You can answer “what is this value right here?” without `print` debugging.

---

## Lesson 9 — Git, files, terminal, sessions

**Goal:** Keep context: repo state, file tree, shell, and workspace all one keypress away.

### Learn — Git

| Keys | Action | Tag |
| --- | --- | --- |
| `]h` / `[h` | Next / previous git hunk | [CFG] |
| `<leader>hp` / `<leader>hb` / `<leader>hl` | Preview hunk / blame line / toggle line blame | [CFG] |
| `<leader>hs` / `<leader>hu` / `<leader>hr` | Stage hunk / undo staged hunk / reset hunk | [CFG] |
| `<leader>hS` / `<leader>hR` | Stage buffer / reset buffer | [CFG] |
| `<leader>hd` | Diff against index | [CFG] |
| `<leader>gt` | Toggle git signs | [CFG] |
| `<leader>gd` / `<leader>gf` / `<leader>gc` | Branch diff / file history / close diff | [CFG] |
| `<leader>tg` | Lazygit in a floating terminal | [CFG] |

### Learn — Neo-tree [CFG/PLUGIN]

| Keys | Action | Tag |
| --- | --- | --- |
| `<C-n>` / `<leader>en` | Toggle filesystem | [CFG] |
| `<leader>eb` / `<leader>eg` | Toggle buffer list / git status panel | [CFG] |
| `q` or `<C-n>` inside Neo-tree | Close Neo-tree | [CFG] |
| `<CR>` inside Neo-tree | Open file in nearest window | [PLUGIN] |
| `<space>` / `c` / `z` inside Neo-tree | Toggle node / close node / close all nodes | [PLUGIN] |
| `a` / `d` / `r` inside Neo-tree | Add / delete / rename file | [PLUGIN] |
| `s` / `S` / `t` inside Neo-tree | Open in vertical split / horizontal split / tab | [PLUGIN] |
| `l` inside Neo-tree | Focus preview | [PLUGIN] |
| `<C-f>` / `<C-b>` inside Neo-tree | Scroll preview down / up | [PLUGIN] |
| `<` / `>` / `<bs>` / `.` inside Neo-tree | Previous source / next source / parent / set root | [PLUGIN] |
| `[g` / `]g` inside Neo-tree | Previous / next modified file | [PLUGIN] |
| `P` inside Neo-tree | Toggle preview (real window, so Markdown renders) | [CFG] |

### Learn — terminal & sessions [CFG]

| Keys | Action |
| --- | --- |
| `<C-\>` (Normal only) | Toggle default terminal |
| `<leader>tt` | Floating terminal |
| `<leader>tg` | Lazygit float |
| `<C-\><C-n>` (Terminal) | Return to Normal mode |
| `<leader>ss` | Save session for current directory |
| `<leader>sl` | Restore session for current directory |
| `<leader>sr` | Restore **last** session |
| `<leader>sx` | Stop session tracking |

### Try it

1. `<C-n>` opens the tree; move with `j`/`k`, `<CR>` opens a file.
2. Hover a `README*` file: its rendered preview appears automatically.
3. `]h` to a change, `<leader>hp` to preview, `<leader>hs` to stage.
4. `<leader>tt` for a shell; `<C-\><C-n>` back to Normal.
5. `<leader>ss` to save; later `<leader>sr` to restore your last workspace.

### Checkpoint

You can move from code → git state → file tree → shell → saved workspace
without breaking flow.

---

## Lesson 10 — Markdown and documentation

**Goal:** Read and write docs in the same buffer, with no preview window.

README files and any `*.md` file open in a rendered, in-place preview:
headings, lists, code blocks, tables, links, and quotes are displayed directly.

| Keys | Action | Tag |
| --- | --- | --- |
| `<leader>mp` | Toggle rendered preview / raw Markdown | [CFG] |
| `i`, edit, `<Esc>` | Insert mode shows raw source; leaving Insert restores preview | [CFG] |
| `P` in Neo-tree | Toggle preview manually | [CFG] |

In Neo-tree, moving the cursor onto a `README*` file shows the rendered preview
in the nearest editor window. `<CR>` opens that file for real editing.

> This README is itself rendered. Press `<leader>mp` to see the raw source, then
> `<leader>mp` again to restore the preview.

### Try it

1. Open this file or a project README.
2. Press `<leader>mp`; observe raw Markdown, then toggle back.
3. Press `i`, edit a word, `<Esc>`; preview returns automatically.

### Checkpoint

Documentation is a first-class buffer, not a separate browser tab.

---

## Lesson 11 — Language labs: Java and Rust

**Goal:** Use the language-specific accelerators when they apply.

### Java [CFG]

| Keys | Action |
| --- | --- |
| `<leader>jo` | Organize imports |
| `<leader>jt` / `<leader>jn` | Test current class / nearest method |
| `<leader>jc` | Compile project |
| `<leader>jr` | Restart Java language server |

### Rust [CFG]

| Keys | Action |
| --- | --- |
| `<leader>rr` / `<leader>rd` / `<leader>rt` | Runnables / debuggables / testables |
| `<leader>rT` | Related tests |
| `<leader>rh` | Hover actions |
| `<leader>rE` | Explain error |

### Lab notes

- `rust_analyzer` is owned by rustaceanvim; `jdtls` by nvim-jdtls. Do not add
  duplicate LSP setups.
- Java uses local Temurin JDK 21 via `JAVA_HOME`/`PATH`; do not add `nvim-java`.
- Re-run `:NeotestJava setup` if the JUnit jar is removed.
- Rust tests prefer cargo-nextest with `cargo test` fallback; Lua uses `busted`;
  Python uses `pytest` (install in the project venv).
- JS/TS/React linting needs a project ESLint config. Prettier, Vitest, Jest,
  and npm packages are per-project.
- C/C++ prefers `compile_commands.json`; CMake projects can use the ctest
  adapter. SQL uses `sqlls` + `sqlfluff`.
- Remote providers are disabled; `:checkhealth` warnings about optional Ruby,
  Gem, Composer, PHP, and Julia are harmless.

### Checkpoint

You know which prefix to try when a language needs something beyond the LSP.

---

# PART II — tmux Class

tmux keeps sessions, windows, and panes organized. The prefix is **Ctrl+A**.
Repeat it to send a literal Ctrl+A to the program.

Reload after editing:

```sh
tmux source-file ~/.tmux.conf
```

Start a session:

```sh
tmux new -s work
```

## Lesson 12 — Sessions and windows

**Goal:** Detach, reattach, and name workspaces.

| Key | Action |
| --- | --- |
| `<prefix> d` | Detach from the current session |
| `tmux ls` | List sessions |
| `tmux attach -t work` | Reattach to `work` |
| `<prefix> $` | Rename the current session |
| `<prefix> r` | Reload the config |
| `<prefix> c` | New window in the current directory |
| `<M-1>` … `<M-5>` | Jump to window 1–5 (no prefix) |
| `<prefix> n` / `<prefix> p` | Next / previous window |
| `<prefix> ,` | Rename the current window |

**Try it:** `tmux new -s class`, `<prefix> c`, `<M-2>`, `<prefix> ,`, name it
`editor`, `<prefix> d`, then `tmux attach -t class`.

## Lesson 13 — Panes

**Goal:** Build a dashboard: editor, tests, shell.

| Key | Action |
| --- | --- |
| `<prefix> \|` | Split vertically (new pane on the right) |
| `<prefix> -` | Split horizontally (new pane below) |
| `<prefix> %` / `<prefix> "` | Same splits, preserving current directory |
| `<M-Left/Right/Up/Down>` | Move between panes (no prefix) |
| `<C-Left/Right/Up/Down>` | Resize panes by 5 cells (no prefix) |
| `<prefix> z` | Zoom / unzoom the current pane |
| `<prefix> x` | Close the current pane |

Mouse support is on: click to focus, drag borders to resize, scroll to browse.

**Try it:** split right for Neovim, split below for tests, zoom with
`<prefix> z` when you need focus.

## Lesson 14 — Copy mode

**Goal:** Copy terminal output without the mouse.

| Key | Action |
| --- | --- |
| `<prefix> [` | Enter copy mode |
| `v` | Begin selection |
| `V` | Select whole line |
| `y` or `<Enter>` | Copy to system clipboard and exit |
| `<Esc>` | Cancel |

`j`/`k` or arrows scroll; `/` searches. The status bar is minimal: session name
left, window names center, active window slightly brighter. No clock or date.
Ensure `TERM=tmux-256color` inside tmux and truecolor in the terminal.

---

# PART III — Prompt & Shell Class

## Lesson 15 — Reading the prompt

**Goal:** Read command status at a glance.

The prompt is two lines:

```text
~/projects/myapp
❯
```

- Top line: **only the current directory name** (`~` at home).
- Bottom line: colored `❯`:
  - **green** — last command succeeded
  - **red** — last command failed
  - **blue `❮`** — Zsh vi-command mode

Colors follow Catppuccin Mocha. No git pile, language versions, icons, time, or
command duration.

Zsh exports local Temurin JDK as `JAVA_HOME` and prepends it to `PATH`, so
`java`, `javac`, and Java tooling work in the terminal too.

Reload after editing:

```sh
exec zsh
```

Starship is initialized from `~/.zshrc`; if the prompt disappears, ensure it
still contains `eval "$(starship init zsh)"`.

---

# PART IV — Reference & Cheat Sheets

## Appendix A — Complete shortcut matrix (all configured keys)

### Leader groups

| Keys | Action |
| --- | --- |
| `<leader>?` | Show all keymaps |
| `<leader>bb` | Build current project |
| `<leader>br` | Restart last task |
| `<leader>bo` | Open last task output |
| `<leader>bt` | Toggle task list |
| `<leader>ca` | Code action |
| `<leader>cf` | Format buffer |
| `<leader>cl` | Code lens |
| `<leader>cR` | References |
| `<leader>cr` | Rename symbol |
| `<leader>cT` | Type definition |
| `<leader>ci` | Toggle inlay hints |
| `<leader>cs` | Document symbols |
| `<leader>du` | Toggle debug UI |
| `<leader>dr` | DAP REPL |
| `<leader>dw` | Hover debug value |
| `<leader>dl` | Lua debug server (osv) |
| `<leader>en` | Toggle Neo-tree filesystem |
| `<leader>eb` | Toggle Neo-tree buffers |
| `<leader>eg` | Toggle Neo-tree git status |
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fc` | Grep word under cursor |
| `<leader>fb` | Open buffers |
| `<leader>fr` | Recent files |
| `<leader>fs` | Find symbol in project (LSP workspace symbols, ripgrep fallback) |
| `<leader>fh` | Help tags |
| `<leader>fk` | Search keymaps |
| `<leader>fR` | Replace word/selection project-wide |
| `<leader>fF` | Replace in current file |
| `<leader>gd` | Branch diff |
| `<leader>gf` | File history |
| `<leader>gc` | Close diff view |
| `<leader>gt` | Toggle git signs |
| `<leader>hp` | Preview hunk |
| `<leader>hb` | Blame line |
| `<leader>hl` | Toggle line blame |
| `<leader>hs` | Stage hunk |
| `<leader>hu` | Undo staged hunk |
| `<leader>hr` | Reset hunk |
| `<leader>hS` | Stage buffer |
| `<leader>hR` | Reset buffer |
| `<leader>hd` | Diff against index |
| `<leader>jo` | Java organize imports |
| `<leader>jt` | Java test class |
| `<leader>jn` | Java nearest test method |
| `<leader>jc` | Java compile |
| `<leader>jr` | Java restart LSP |
| `<leader>mp` | Toggle Markdown render |
| `<leader>nt` | Nearest test |
| `<leader>nf` | Test file |
| `<leader>na` | All tests |
| `<leader>nb` | Debug nearest test |
| `<leader>nl` | Rerun last test |
| `<leader>ns` | Test summary |
| `<leader>no` | Test output |
| `<leader>nS` | Stop tests |
| `<leader>o` | Toggle symbol outline |
| `<leader>rr` | Rust runnables |
| `<leader>rd` | Rust debuggables |
| `<leader>rt` | Rust testables |
| `<leader>rT` | Rust related tests |
| `<leader>rh` | Rust hover actions |
| `<leader>rE` | Rust explain error |
| `<leader>ss` | Save session |
| `<leader>sl` | Restore session for current dir |
| `<leader>sr` | Restore last session |
| `<leader>sx` | Stop session tracking |
| `<leader>tt` | Floating terminal |
| `<leader>tg` | Lazygit float |
| `<leader>uh` | Clear search highlight |
| `<leader>uw` | Toggle line wrap |
| `<leader>ws` | Save buffer |
| `<leader>wq` | Close buffer, keep layout |
| `<leader>wQ` | Force-close buffer, keep layout |
| `<leader>xx` | Workspace diagnostics |
| `<leader>xX` | Buffer diagnostics |
| `<leader>xq` | Quickfix list |

> Corrections to older notes: `<leader>gg` is **not** mapped (use
> `<leader>tg`), `ss`/`sl`/`sr`/`sx` are save / restore-current-dir / restore-last
> / stop, and there is no `[` / `]` blank-line mapping.

### Non-leader keys by context

| Context | Keys | Action |
| --- | --- | --- |
| Normal | `<C-h/j/k/l>` | Move focus between splits |
| Normal | `<C-Up/Down>` | Grow / shrink height |
| Normal | `<C-Left/Right>` | Shrink / grow width |
| Normal | `<Tab>` / `<S-Tab>` | Next / previous buffer |
| Normal | `n` / `N` | Centered next / previous search result |
| Normal | `<C-o>` / `<C-i>` | Jump back / forward in the jumplist (return after `gd`) |
| Normal | `<C-\>` | Toggle default terminal |
| Normal | `<C-w>d` | Diagnostic under cursor |
| Visual | `J` / `K` | Move selection down / up |
| Visual | `<` / `>` | Outdent / indent selection |
| Insert | `<Tab>` / `<S-Tab>` | Completion / snippet navigation |
| Insert | `<C-Space>`, `<CR>`, `<C-e>`, `<C-b>`, `<C-f>` | Completion control |
| Terminal | `<C-\><C-n>` | Back to Normal mode |
| Flash | `s`, `S`, `r`, `R` | Jump / treesitter jump / remote / search |
| Comment | `gcc`, `gc{motion}`, `gb`, `gco`, `gcO`, `gcA` | Comment operations |
| Surround | `ys`, `ds`, `cs`, `gS`, `<C-g>s` | Add / delete / change surround |
| Format | `gq{motion}` | Format region with conform |
| Helper windows | `q` | Close help/qf/checkhealth/lspinfo/man/notify/Trouble |
| Telescope | `<C-j/k>`, `<C-q>`, `<CR>`, `<Esc>` | Move / send to qf / select / close |
| Neo-tree | `<CR>`, `<space>`, `a`, `d`, `r`, `s`, `S`, `t`, `l`, `P`, `q` | Open, toggle, file ops, splits, preview, close |
| Trouble | `?`, `q`, `<CR>`, `o`, `[[`, `]]`, `r`, `R` | Help, close, jump, navigate, refresh |
| Aerial | `?`, `<CR>`, `q` | Help, jump, close |
| Overseer list | `?`, `<CR>`, `dd`, `<C-e>`, `o`, `p`, `{`, `}` | Help, action, dispose, edit, output, preview, navigate |
| grug-far | `<Tab>`, `\r`, `\c`, `<CR>`, `g?` | Fields, apply, close, jump, help |
| DAP UI | `<CR>`, `o`, `d`, `e`, `r`, `t`, `w`, `q` | Expand, open, remove, edit, REPL, toggle, watch, close |

## Appendix B — What is included

- **LSP**: `lua_ls`, `pyright`, `gopls`, `ts_ls`, `html`, `cssls`, `jsonls`,
  `emmet_language_server`, `sqlls`, `clangd`, `eslint`. `rust_analyzer` is owned
  by rustaceanvim; `jdtls` by nvim-jdtls (JavaSE-21 runtime).
- **Completion**: nvim-cmp + LuaSnip + friendly snippets.
- **Formatting** (format-on-save): StyLua, rustfmt, `ruff_fix` + `ruff_format`,
  gofumpt, Prettier, clang-format, google-java-format, sqlfluff, shfmt.
- **Linting**: selene, clippy, ruff, golangci-lint, eslint-lsp, htmlhint,
  stylelint, clang-tidy, checkstyle, sqlfluff.
- **Testing**: neotest with rustaceanvim, plenary, python, go, vitest, jest,
  java, gtest, and ctest adapters.
- **Build and tasks**: overseer.nvim — smart builds, quickfix errors,
  `.vscode/tasks.json`, DAP `preLaunchTask` support.
- **Find and replace**: grug-far.nvim — previewed project-wide replacement.
- **Debugging**: codelldb, debugpy, delve, js-debug-adapter, jdtls adapter, osv,
  automatic `.vscode/launch.json` detection.
- **Navigation**: Telescope (fzf-native), Neo-tree, Flash, Aerial, Trouble,
  diffview.nvim, layout-preserving buffer close via mini.bufremove.
- **Markdown**: render-markdown.nvim — in-place rendered preview; README files
  auto-preview in Neo-tree.
- **UI**: Catppuccin Mocha (transparent), Lualine, which-key, dressing,
  nvim-notify, sessions, and Fidget LSP progress.
- **Git**: gitsigns, diffview.nvim, lazygit.

## Appendix C — Productivity playbooks

### Morning startup

```text
cd ~/Projects/client/SONORA
nvim
<leader>sl          restore this directory's session
<C-n>               reveal the file tree
<leader>xx          check workspace diagnostics
<leader>bb          build before you edit
```

### Feature work

```text
<C-p>               find the file
<leader>o           jump by symbol in this file
<leader>fs          jump by symbol in the whole project
K / <C-k>           read the function's description / call signature
<leader>cR          find references before changing a signature
edit with ciw / ci" / s / gcc
<leader>cf          format
<leader>nt          nearest test
<leader>bb          build
```

### Bug hunt

```text
reproduce in <leader>tt
<leader>fg          search the error message
]d / <leader>xx     read diagnostics
<F9> on suspicious line
<F5> <F10> <F11> <leader>dw
<leader>cr or <leader>fR once the fix is known
```

### Safe refactor

```text
<leader>fc          confirm every usage
<leader>cr          rename the symbol (LSP-aware)
<leader>fR          only for strings/comments the LSP cannot see
<leader>na          all tests
<leader>bb          full build
```

### Code review

```text
<leader>gd          branch diff
<leader>gf          history of this file
]h / <leader>hp     walk and preview hunks
<leader>tg          lazygit for the big picture
```

### Documentation sprint

```text
<C-n>               hover README -> auto preview
<CR>                open it for editing
<leader>mp          toggle raw when fixing tables/links
i ... <Esc>         raw while editing, rendered when done
<leader>ws          save
```

## Appendix D — 30-day practice curriculum

| Week | Focus | Daily drill |
| --- | --- | --- |
| 1 | Motions & operators | 5 minutes: `w/b/e`, `f/t`, text objects, `.` repeat. No arrows. |
| 2 | Search & replace | One `<leader>fc` and one `<leader>fR` per day, always review before `\r`. |
| 3 | LSP & build loop | For every edit: `K`, `gd`, `<leader>cf`, `<leader>nt`, `<leader>bb`. |
| 4 | Debugging & git | Set one breakpoint with `<F9>` and stage one hunk with `<leader>hs` daily. |

By day 30 the goal is not more memorized keys; it is that the editor stops
interrupting your thought process.

---

# PART V — Maintenance

```sh
nvim +Lazy check      # plugin updates (inside Neovim: :Lazy check)
nvim +checkhealth     # health report (inside Neovim: :checkhealth)
:Mason                # manage LSP/DAP/formatter binaries
:ConformInfo          # inspect formatter setup
```

Common fixes:

- **LSP not starting** — `:Mason`, confirm the server is installed, restart
  Neovim.
- **Formatter missing** — install it with `:Mason` or your package manager.
- **JS/TS diagnostics missing** — add `eslint.config.mjs` (or legacy config) to
  the project.
- **Icons look wrong** — use **JetBrainsMono Nerd Font**.
- **tmux colors flat** — `TERM=tmux-256color` inside tmux and truecolor enabled
  in the terminal; the config sets RGB overrides automatically.
- **Which-key feels slow** — `timeoutlen` is 400 ms in `lua/options.lua`.

Known key conflicts worth remembering:

- Visual `S`: Flash treesitter vs nvim-surround. Use `gS` when you mean surround.
- `<C-k>`: window-left globally, signature help in LSP buffers, previous result
  in Telescope.
- `<C-n>`: toggle Neo-tree globally, close it inside Neo-tree, completion in
  Insert mode.
- Normal `s` is Flash, not stock Vim’s substitute-character.
