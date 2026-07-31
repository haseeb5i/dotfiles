# Editor Audit & Alignment — Neovim (LazyVim) + Zed

**Audited:** 2026-07-29
**Neovim:** v0.12.4 (LuaJIT 2.1.1767980792) · **LazyVim:** v16.0.0 (tag `stable`, commit `c10948c5`) · **lazy.nvim:** v11.17.5 (tag `stable`, commit `85c7ff37`)
**Zed:** 1.12.1 (commit `2a37601c02a32b22e7700835c04b89ff75ffcd5d`, `/home/raven/.local/zed.app/libexec/zed-editor`)
**Scope:** every file under `/home/raven/.config/nvim` and `/home/raven/.config/zed`.

> **Docs convention:** verified none exists. No `*.md`, `docs/`, or `notes/` at the root of either config dir (`find -maxdepth 2`). This file is therefore new and self-contained.

> **⚠️ Both configs are chezmoi-managed.** Source of truth is
> `/home/raven/.local/share/chezmoi/dot_config/nvim/` and `/home/raven/.local/share/chezmoi/dot_config/zed/`
> (the latter as `private_settings.json`, `private_keymap.json`, `tasks.json`, `snippets/`, `themes/`).
> Apply every change below via `chezmoi edit` or `chezmoi re-add`, otherwise the next `chezmoi apply` reverts it.

---

## 1. Summary

**Headline: both configs are in good shape.** Neovim starts with zero errors (`nvim --headless +qa` → exit 0, no stderr). Zed's `settings.json` and `keymap.json` are valid JSONC with no duplicate keys, and **all 56 distinct action names in `keymap.json` are valid** against the 1381 actions published in Zed's official action reference. There is no systemic breakage in either editor — the findings are a handful of dead settings, two genuine keybinding collisions, and one real typo.

### Severity-ranked findings

| # | Sev | Editor | Finding | Location |
|---|-----|--------|---------|----------|
| N2 | **High** | nvim | `<A-p>` → `BufferLinePick` is shadowed in every LSP buffer by LazyVim's buffer-local `<a-p>` "Prev Reference" | `lua/config/keymaps.lua:15` |
| Z1 | **High** | Zed | `space e` is bound 3× in overlapping contexts; per Zed's precedence rule `pane::RevealInProjectPanel` is **dead code** | `keymap.json:25` vs `:117` |
| N3 | **Med** | nvim | `cmdheight = 0` while `noice.nvim` is disabled → command line and messages hidden, hit-enter prompts | `options.lua:5` + `disabled.lua:7` |
| N4 | **Med** | nvim | `vim.keymap.del("n", ...)` deletes only normal mode; LazyVim maps `<c-/>`/`<c-_>` for `{"n","t"}`, so terminal-mode maps survive. Also hard-errors if LazyVim ever drops the map | `keymaps.lua:18-19` |
| Z2 | **Med** | Zed | `agent.inline_assistant_model` is not a valid key in 1.12.1 — silently ignored | `settings.json:61-64` |
| Z3 | **Med** | Zed | `g f` overrides vim's `gf` (`editor::OpenSelectedFilename`) | `keymap.json:104` |
| Z4 | **Med** | Zed | `shift-q` overrides `Q` (`vim::ReplayLastRecording`) — macro replay lost | `keymap.json:35` |
| Z5 | **Low-Med** | Zed | `edit_predictions.enabled_in_text_threads` is not a valid key in 1.12.1 | `settings.json:103` |
| N5 | **Low-Med** | nvim | `conform` configures `isort`/`black`; neither is installed nor mason-managed, and no python extra is enabled | `lua/plugins/lsp.lua:24` |
| Z6 | **Low** | Zed | `g c` in visual re-binds `editor::ToggleComments` over vim's own `vim::ToggleComments` — redundant, loses vim-native mode handling | `keymap.json:135` |
| N6 | **Low** | nvim | `LazyVim.lualine.cmp_source("codeium")` can never render — it early-returns unless `package.loaded["cmp"]`, and this config uses blink.cmp | `lua/plugins/ui.lua:34` |
| N7 | **Low** | nvim | `lazy-lock.json` has an orphaned `flash.nvim` entry (38 locked vs 37 in spec) | `lazy-lock.json` |
| N8 | **Low** | nvim | `.neoconf.json` configures `neodev`, which is not installed (superseded by `lazydev.nvim`) | `.neoconf.json:2-7` |
| N9 | **Low** | nvim | Dead/no-op config: `<D-s>` macOS maps on Linux, redundant `gx`, empty `dap.lua`, all-commented `coding.lua`, `bufferline opts = {}`, stray `debug.lua`, `vim.g.ai_cmp` with no AI extra, copilot autocmds with no copilot | several |
| Z7 | **Low** | Zed | `tasks.json` still contains the shipped "Example task" boilerplate (`env: {foo: bar}`) | `tasks.json:12-54` |

### Top 5 actions

2. **Resolve Zed's `space e`** — delete the dead `pane::RevealInProjectPanel` at `keymap.json:25`, or move it to a distinct key (`space f e` is proposed in §5).
3. **Move `<A-p>` off BufferLinePick** in nvim (e.g. `<leader>bp`) — it does nothing in any file with an LSP attached.
4. **Decide on `cmdheight`** — either re-enable noice or set `cmdheight = 1`. Currently messages are invisible.
5. **Delete the two dead Zed settings** (`agent.inline_assistant_model`, `edit_predictions.enabled_in_text_threads`) and add the alignment block from §5 (rename / code-action / symbols / splits / hunk-nav are all unbound in Zed today).

---

## 2. Neovim findings

Primary sources: the installed LazyVim v16.0.0 tree at `/home/raven/.local/share/nvim/lazy/LazyVim/` (highest trust), lazy.nvim v11.17.5, and https://www.lazyvim.org/configuration/general.


### N2 — HIGH · `<A-p>` collides with LazyVim's LSP reference navigation

`/home/raven/.config/nvim/lua/config/keymaps.lua:13-15`

```lua
map("n", "<A-p>", "<cmd>BufferLinePick<cr>", { desc = "Pick a buffer" })
```

LazyVim binds `<a-p>` to "Prev Reference" in its wildcard LSP server spec
(`LazyVim/lua/lazyvim/plugins/lsp/init.lua`, the `servers["*"].keys` list, alongside `<a-n>`, `]]`, `[[`).
Those keys are applied through `Snacks.keymap.set` with an `lsp` filter, and snacks sets them **buffer-local**:

`/home/raven/.local/share/nvim/lazy/snacks.nvim/lua/snacks/keymap.lua:89`
```lua
vim.keymap.set(map.mode, map.lhs, map.rhs, Snacks.config.merge(map.opts or {}, { buffer = buf }))
```

Buffer-local mappings take precedence over global ones, so in any buffer with an LSP client advertising `documentHighlight`, `<A-p>` jumps to the previous reference and `BufferLinePick` is unreachable. Verified that the *global* map exists as written (runtime probe after `doautocmd User VeryLazy`: `<M-p> => Pick a buffer`); the collision is with the later buffer-local map.

`<A-h>` / `<A-l>` (`keymaps.lua:13-14`) are clean — LazyVim binds no `<A-h>`/`<A-l>`, only `<A-j>`/`<A-k>` for move-line (`lazyvim/config/keymaps.lua:26-31`).

### N3 — MED · `cmdheight = 0` with noice disabled

`options.lua:5` sets `vim.opt.cmdheight = 0`; `disabled.lua:7` sets `{ "folke/noice.nvim", enabled = false }`.

LazyVim itself never sets `cmdheight` — verified: `grep -rn 'cmdheight' LazyVim/lua/` returns **nothing**. `cmdheight = 0` is only comfortable when a replacement message UI (noice) is present; without it, `:` command output, `echo`, search counts and errors have nowhere to render and Neovim falls back to hit-enter prompts that shift the layout. Runtime confirms `cmdheight=0` is in effect. Either re-enable noice or use `cmdheight = 1`.

### N4 — MED · Partial and fragile keymap deletion

`/home/raven/.config/nvim/lua/config/keymaps.lua:18-19`

```lua
vim.keymap.del("n", "<c-/>")
vim.keymap.del("n", "<c-_>")
```

**Load order is correct** — verified in `LazyVim/lua/lazyvim/config/init.lua:294-300`:

```lua
  -- always load lazyvim, then user file
  if M.defaults[name] or name == "options" then
    _load("lazyvim.config." .. name)
    ...
  end
  _load("config." .. name)
```

LazyVim's own keymaps load first, so deleting them from `lua/config/keymaps.lua` is the documented, working approach (LazyVim's `keymaps.lua:3-4` explicitly says *"DO NOT USE `LazyVim.safe_keymap_set` IN YOUR OWN CONFIG!! use `vim.keymap.set` instead"* — this config complies).

Two real issues remain:

1. **Incomplete deletion.** LazyVim maps both keys for *two* modes (`lazyvim/config/keymaps.lua:195-196`):
   ```lua
   map({"n","t"}, "<c-/>", function() Snacks.terminal.focus(nil, { cwd = LazyVim.root() }) end, ...)
   map({"n","t"}, "<c-_>", function() Snacks.terminal.focus(nil, { cwd = LazyVim.root() }) end, ...)
   ```
   Only the `"n"` maps are deleted, so `<c-/>` and `<c-_>` still focus the terminal from terminal mode, competing with the intended `<c-\>`. Add `vim.keymap.del("t", "<c-/>")` and `vim.keymap.del("t", "<c-_>")`.
2. **Breaks on update.** `vim.keymap.del` raises `E31: No such mapping` if the map is absent. If LazyVim renames or drops `<c-/>` in a future release, startup errors. Guard with `pcall`, or use the tolerant form shown in §5.

Also note a small semantic drift: LazyVim uses `Snacks.terminal.focus(...)`, the replacement at `keymaps.lua:20-22` uses `Snacks.terminal(...)` — toggle/open rather than focus-existing.

### N5 — LOW-MED · Formatters configured but absent

`lua/plugins/lsp.lua:21-27` adds `python = { "isort", "black" }`. Verified: `isort` and `black` are **not on PATH** and **not in mason** (mason packages: `lua-language-server, eslint-lsp, taplo, prettier, vtsls, stylua, shfmt, tailwindcss-language-server, bash-language-server, shellcheck, json-lsp`). No `lazyvim.plugins.extras.lang.python` is enabled in `lazyvim.json`, so nothing will install them. Python formatting silently no-ops.

### N6 — LOW · Dead lualine component

`lua/plugins/ui.lua:34` — `table.insert(opts.sections.lualine_x, 2, LazyVim.lualine.cmp_source("codeium"))`.

`LazyVim/lua/lazyvim/util/lualine.lua`:
```lua
function M.cmp_source(name, icon)
  icon = icon or LazyVim.config.icons.kinds[name:sub(1, 1):upper() .. name:sub(2)]
  local started = false
  return M.status(icon, function()
    if not package.loaded["cmp"] then
      return
    end
```

This config uses **blink.cmp**, so `package.loaded["cmp"]` is never set and the component always renders empty. No codeium extra is enabled either. Harmless (the icon `Codeium` does exist at `lazyvim/config/init.lua:63`, so no nil error) but dead.

**The surrounding table surgery is safe** — verified against `LazyVim/lua/lazyvim/plugins/ui.lua:112-160`: `lualine_x` has 6 entries (so `insert` at index 2 is in bounds) and `lualine_y` has 2 (`progress`, `location`), so `table.remove(opts.sections.lualine_y, 1)` is valid.

### N7 — LOW · Stale lock file

Resolved spec = 37 plugins, `lazy-lock.json` = 38. Orphan: **`flash.nvim`** (disabled at `disabled.lua:4`). Cosmetic; clears on the next `:Lazy update`/`:Lazy restore`.

### N8 — LOW · `.neoconf.json` targets a removed plugin

`/home/raven/.config/nvim/.neoconf.json:2-7` configures `neodev`. Neither `neoconf.nvim` nor `neodev.nvim` is installed (the plugin list contains **`lazydev.nvim`**, which superseded neodev). The file is inert.

### N9 — LOW · Dead / no-op configuration

| Location | Issue |
|---|---|
| `keymaps.lua:35-37` | `<D-s>` (Cmd) maps — macOS only, this is Linux |
| `keymaps.lua:30-32` | `gx` reimplemented with `xdg-open`; Neovim ≥0.10 already provides `gx` via `vim.ui.open` |
| `lua/plugins/dap.lua` | `return {}` — empty, and no DAP extra enabled |
| `lua/plugins/coding.lua` | `opts = {}` with every line commented out |
| `lua/plugins/ui.lua:2-5` | `bufferline` `opts = {}` — no-op |
| `debug.lua` | Stray scratch file at config root; references `neo-tree`, which isn't used (snacks explorer is) |
| `options.lua:15` | `vim.g.ai_cmp = true` — already LazyVim's default (`lazyvim/config/options.lua:26`) and meaningless with no AI extra enabled |
| `autocmds.lua:30-43` | `BlinkCmpMenuOpen/Close` → `vim.b.copilot_suggestion_hidden`; copilot is not installed |
| `lazy.lua:25` vs `themes.lua:5` | `install.colorscheme = { "dracula", "habamax" }` but the active colorscheme is `tokyonight` |

### Verified NOT problems

These looked suspicious and are actually correct — recorded so they aren't "fixed" by mistake:

- **`servers["*"].keys` in `lua/plugins/lsp.lua:7-17` is fully supported and *extends* rather than clobbers.** `LazyVim/lua/lazyvim/plugins/lsp/init.lua:10` declares `opts_extend = { "servers.*.keys" }`; `:63-68` documents `["*"]` as *"the default configuration for an LSP client (or all clients if the special name `\"*\"` is used)"*; `:174-175` dispatches `server_opts.keys`. So `gh`/`cd`/`g.` are added alongside LazyVim's `K`/`<leader>cr`/`<leader>ca`, not in place of them.
- **`vim.g.lazyvim_picker = "snacks"` is valid.** LazyVim's own template comment (`lazyvim/config/options.lua:13`) still says *"telescope, fzf"*, but that comment is stale: verified at runtime that `vim.g.lazyvim_picker == "snacks"` survives and the `snacks_picker` extra is present in the resolved spec, with no "Invalid value" notification (the error path is `lazyvim/config/init.lua:372-379`).
- **Disabling `flash.nvim` is clean.** `LazyVim/lua/lazyvim/plugins/extras/editor/snacks_picker.lua:224-227` declares flash with `optional = true` and nests the picker `s`/`<a-s>` flash keys inside flash's own `specs = { ... }`, so disabling flash removes the whole fragment. No dangling `require("flash")` in picker actions.
- **`treesitter.lua` works.** LazyVim v16 uses nvim-treesitter `branch = "main"` with `opts_extend = { "ensure_installed" }` and a table `opts.ensure_installed` (`lazyvim/plugins/treesitter.lua:8,25,28-33`), so `vim.list_extend(opts.ensure_installed, { "solidity" })` is fine. The idiomatic equivalent given `opts_extend` is simply `opts = { ensure_installed = { "solidity" } }`.
- **Referencing `"snacks.nvim"` by short name** (`editor.lua:5`) is valid lazy.nvim spec syntax for extending an already-declared plugin.
- **`nvim-lint` `linters_by_ft = {}`** merges to a no-op; harmless.
- **`:checkhealth lazy`** reports only the benign luarocks block, prefaced by LazyVim's own *"OK no plugins require `luarocks`, so you can ignore any warnings below"*.
- **No deprecated API usage found.** No `vim.tbl_add_reverse_lookup`, `vim.lsp.buf_get_clients`, `null-ls`, or legacy `lspconfig.setup()` calls. `vim.diagnostic.jump` (the 0.11+ API) is what LazyVim itself uses.

---

## 3. Zed findings

Primary sources, all pinned to the **installed** version `v1.12.1`:
`assets/settings/default.json` (2812 lines), `assets/keymaps/default-linux.json` (1608), `assets/keymaps/vim.json` (1250), plus https://zed.dev/docs/all-actions (1381 actions), /key-bindings, /vim, /configuring-zed.

**Method note:** I attempted to validate action names with `strings` on the `zed-editor` binary. It returned 0 hits even for certainly-valid controls like `editor::Format`, so the method is invalid (action names are assembled at compile time) and its results are discarded. Validation below is against the published action reference instead.

### Clean bills of health

- `settings.json`, `keymap.json`, `tasks.json`, `snippets/javascript.json` all parse as JSONC. **No duplicate keys** (23 top-level keys, all unique). No trailing-comma or type errors.
- **All 56 distinct actions in `keymap.json` are valid**, checked against the 1381 actions in https://zed.dev/docs/all-actions.
- **Both parameterised bindings are correct**, verified against Zed's Rust source at tag `v1.12.1`:
  - `["editor::GoToDiagnostic", { "severity": "error" }]` — `GoToDiagnosticSeverityFilter` in `crates/project/src/project_settings.rs` is `#[serde(untagged)]` with an `Only(GoToDiagnosticSeverity)` variant, so a bare string is accepted (Zed's own default uses the `Range` form `{min,max}` at `default-linux.json:561`).
  - `["pane::CloseAllItems", { "close_pinned": false }]` — `crates/workspace/src/pane.rs` defines `pub struct CloseAllItems { save_intent, close_pinned }`.
- `agent.default_model.enable_thinking` **is** valid — `default.json` ships `"default_model": {"provider":"zed.dev","model":"claude-sonnet-4","enable_thinking":false}`.
- `lsp.vtsls.enable_lsp_tasks` **is** a valid per-server key — documented in `default.json:2527-2531`.
- `edit_predictions.provider` is the current key; the older `features.edit_prediction_provider` is gone (`features` is **absent** from 1.12.1's `default.json`). This config is on the modern key.
- All three `auto_install_extensions` (`html`, `sql`, `prisma`) are actually installed (`~/.local/share/zed/extensions/installed`), and `vtsls` is present in `~/.local/share/zed/languages`, so the `lsp.vtsls` block is live.
- `"space m P"` — a bare uppercase letter in a sequence is valid; Zed's own `vim.json` uses `g B`. It is merely stylistically inconsistent with `"space b shift-p"` two blocks earlier.
- `diff_view_style: "unified"` is a valid value (`default.json:363-372` documents `split` as default and describes automatic switching to `unified`).

### Z1 — HIGH · `space e` bound three times; one binding is dead

- `keymap.json:25` — context `Editor && vim_mode == normal && !VimWaiting && !menu` → `pane::RevealInProjectPanel`
- `keymap.json:117` — context `Editor && VimControl && !menu` → `workspace::ToggleLeftDock` *(the config's own comment reads `// find better context?`)*
- `keymap.json:151` — context `ProjectPanel && not_editing` → `project_panel::ToggleFocus` *(no conflict — different node)*

`VimControl` covers normal mode, so in normal mode the first two both match, and both are anchored at `Editor` — the same node in the context tree. Per https://zed.dev/docs/key-bindings#precedence:

> *"Bindings that match on lower nodes in the context tree win… If there are multiple bindings that match at the same level in the tree, then the binding defined later takes precedence."*

The later one wins, so **`space e` always toggles the left dock and `pane::RevealInProjectPanel` at `:25` is unreachable.** Fix in §5.

### Z2 — MED · `agent.inline_assistant_model` does not exist in 1.12.1

`settings.json:61-64`
```json
        "inline_assistant_model": {
            "provider": "copilot_chat",
            "model": "gpt-4o"
        }
```

The `agent` object in `v1.12.1/assets/settings/default.json` has 31 keys:
`inline_assistant_use_streaming_tools, commit_message_include_project_rules, enabled, button, dock, flexible, sidebar_side, default_width, default_height, limit_content_width, max_content_width, default_model, model_parameters, tool_permissions, single_file_review, auto_compact, enable_feedback, default_profile, profiles, notify_when_agent_waiting, play_sound_when_agent_done, expand_edit_card, expand_terminal_card, terminal_init_command, thinking_display, cancel_generation_on_terminal_stop, use_modifier_to_send, message_editor_min_lines, show_turn_stats, show_merge_conflict_indicator`.

`inline_assistant_model` is **not** among them (the only `inline_assistant*` key is `inline_assistant_use_streaming_tools`). The gpt-4o preference is being ignored; the inline assistant uses `agent.default_model` (gpt-4.1). Delete the block, or raise it to `default_model` if gpt-4o was the intent.

*(`sidebar_side` **and** `dock` are both set at `settings.json:54-55` — both are valid keys, so this is not an error, though setting both is redundant.)*

### Z3 — MED · `g f` shadows vim's go-to-file

`keymap.json:104` binds `g f` → `editor::OpenExcerpts` in `Editor && (vim_mode == normal || vim_mode == visual)`.
`vim.json` binds `g f` → `editor::OpenSelectedFilename` in `VimControl && !menu`.

Same `Editor` node, user file loads later, so `gf` no longer opens the filename under the cursor. `editor::OpenExcerpts` is genuinely useful (it opens the multibuffer excerpt under the cursor as a real buffer) but it deserves its own key — see §5, which moves it to `g x` and restores `g f`.

### Z4 — MED · `shift-q` shadows macro replay

`keymap.json:35` binds `shift-q` → `pane::CloseActiveItem`.
`vim.json` binds `shift-q` → `vim::ReplayLastRecording` in `VimControl && !menu`.

`Q` (replay last macro) is lost. This is also a **cross-editor asymmetry**: in Neovim, `Q` is not a close-buffer key (LazyVim uses `<leader>bd`), so muscle memory built in Zed will not transfer. See §4.

### Z5 — LOW-MED · `edit_predictions.enabled_in_text_threads` does not exist in 1.12.1

`settings.json:103`. The valid `edit_predictions` keys in `v1.12.1/assets/settings/default.json` are exactly:
`provider, disabled_globs, mode, copilot, codestral, ollama, open_ai_compatible_api, allow_data_collection`.
Neither `enabled_in_text_threads` nor any `text_thread` key appears anywhere in `default.json` (`grep -n 'text_thread\|enabled_in'` → no matches). Silently ignored; delete it.

### Z6 — LOW · Redundant visual-mode comment override

`keymap.json:135` binds `g c` → `editor::ToggleComments` for `vim_mode == visual`.
`vim.json` already binds `g c` → **`vim::ToggleComments`** for `vim_mode == visual` (and `vim::PushToggleComments` in normal, `vim::Comment` for the operator).

The vim-native action is the better one — it handles the operator/visual-mode exit the way vim does. This override buys nothing and slightly degrades behaviour. Recommend deleting the block. Also note Zed's vim mode ships `gc`/`gcc` natively (https://zed.dev/docs/vim#supported-plugins), so no binding is needed at all.

### Z7 — LOW · Boilerplate in `tasks.json`

`tasks.json:12-54` is Zed's shipped "Example task" template, including `"env": { "foo": "bar" }`. The real task (`Lazygit`, `:4-11`) is fine and `lazygit` is installed (`/usr/bin/lazygit`). Delete the example.

### Z8 — LOW · Leader key competes with a default binding

`vim.json` binds bare `space` → `vim::WrappingRight` in `VimControl && !menu`. Because `space` is a prefix of every `space …` sequence, https://zed.dev/docs/key-bindings#precedence applies:

> *"When this happens, and both bindings are active in the current context, Zed will wait for 1 second after you type `ctrl-w` to see if you're about to type `left`."*

So a bare `space` in normal mode incurs a 1-second wait before moving right. Neovim has no equivalent penalty (mapping `<leader>` simply shadows `<Space>`). Fix: `"space": null` — see §6.

### Z9 — LOW · `ctrl-|` is likely unreachable

`keymap.json:163` binds `ctrl-|` → `terminal_panel::ToggleFocus`. `|` requires shift on a US layout. Per https://zed.dev/docs/key-bindings#keybinding-syntax, `shift-` *"can only be used in combination with a letter"*, so writing the codepoint `|` directly is the correct syntax — but whether the platform reports `ctrl-|` rather than `ctrl-shift-\` is unverified. Listed in §8; `ctrl-shift-\` is the safer spelling.

---

## 4. Alignment: side-by-side keybinding table

Derived from actual configs **plus** actual defaults: LazyVim `lua/lazyvim/config/keymaps.lua`, its plugin `keys` specs (`plugins/editor.lua`, `plugins/lsp/init.lua`, `plugins/extras/editor/snacks_picker.lua`, `.../snacks_explorer.lua`, `.../harpoon2.lua`), and Zed `default-linux.json` + `vim.json` + `keymap.json`.

Status legend: **✅ aligned** · **🔧 trivially alignable** (one binding on one side) · **⚠️ structurally different**

| Operation | Neovim (LazyVim + this config) | Zed (defaults + this config) | Status |
|---|---|---|---|
| File finder | `<leader><space>`, `<leader>ff` | `space space`, `space f f`; default `ctrl-p` | ✅ |
| Recent files / projects | `<leader>fr`, `<leader>fp` | `space f r` → `projects::OpenRecent` | 🔧 `fr` is *recent files* in nvim vs *recent projects* in Zed |
| Live grep / project search | `<leader>/`, `<leader>sg` | `space /`, `space s g` → `pane::DeploySearch` | ✅ |
| Grep word under cursor | `<leader>sw` (n,x) | unbound | 🔧 |
| Buffer/tab next / prev | `<S-l>` / `<S-h>`; `]b` / `[b` | `shift-l` / `shift-h`; `ctrl-tab` / `ctrl-shift-tab` | ✅ |
| Buffer/tab switcher list | `<leader>,`, `<leader>fb` | `space ,`, `space b b` → `tab_switcher::Toggle` | ✅ |
| Close buffer/tab | `<leader>bd` | `space b d`, **`shift-q`** | 🔧 nvim has no `Q`-close; Zed's `shift-q` also eats `vim::ReplayLastRecording` (Z4) |
| Close other buffers | `<leader>bo` | `space b o` | ✅ |
| Switch to last buffer | `<leader>bb`, `<leader>`` | unbound | 🔧 |
| File tree toggle | `<leader>e` → snacks explorer | `space e` → `workspace::ToggleLeftDock` | ✅ (nuance: nvim reveals current file; Zed just toggles the dock) |
| File tree reveal current file | `<leader>e` (reveals) | `pane::RevealInProjectPanel` — **dead**, see Z1 | 🔧 |
| Document symbols | `<leader>ss`; `<leader>cs` (Trouble) | `outline::Toggle` — default `ctrl-shift-o`, **no leader key** | 🔧 |
| Project symbols | `<leader>sS` | `project_symbols::Toggle` — default `ctrl-t`, **no leader key** | 🔧 |
| Go to definition | `gd` | `g d` → `editor::GoToDefinition` (vim.json) | ✅ |
| Go to references | `gr` | `g r` → `editor::FindAllReferences` | ✅ |
| Go to implementation | `gI` | `g i` = **`vim::InsertAtPrevious`** in VimControl; `GoToImplementation` only in helix mode | 🔧 add `g shift-i` |
| Go to type definition | `gy` | `g y` → `editor::GoToTypeDefinition` (vim.json) | ✅ |
| Go to declaration | `gD` | `g shift-d` → `editor::GoToDeclaration` (vim.json) | ✅ |
| Hover | `K`; also `gh` (this config) | `shift-k` → `editor::Hover` (vim.json); `ctrl-k ctrl-i` | ✅ (`gh` is nvim-only extra) |
| Signature help | `gK`; `<c-k>` (insert) | `g shift-k`, `ctrl-k` (insert) | ✅ |
| Rename | `<leader>cr`; also `cd` (this config) | `f2` only — **no leader key** | 🔧 |
| Code action | `<leader>ca`; also `g.` (this config) | `ctrl-.` only — **no leader key** | 🔧 |
| Format | `<leader>cf` | `space c f` → `editor::Format` | ✅ |
| Line diagnostics | `<leader>cd` | — (`editor::Hover` is nearest) | 🔧 |
| Diagnostics next / prev | `]d` / `[d` | `] d` / `[ d` (vim.json), `g ]` / `g [` | ✅ |
| Error / warning next+prev | `]e` `[e` `]w` `[w` | `] e` `[ e` `] w` `[ w` (this config) | ✅ |
| Diagnostics list | `<leader>xx` (Trouble) | `space x x` → `diagnostics::Deploy` | ✅ |
| Quickfix list | `<leader>xq`; `]q` / `[q` | ⚠️ no quickfix concept — multibuffer/diagnostics panel is the analogue | ⚠️ |
| Save | `<C-s>` (i,x,n,s) | `ctrl-s` (normal + insert) | ✅ |
| Comment toggle | `gcc` / `gc`; `gco` / `gcO` | `g c` (vim-native); `ctrl-/` | ✅ (`gco`/`gcO` nvim-only) |
| Undo / redo | `u` / `<C-r>` | `u` / `ctrl-r` (vim.json); `ctrl-z` / `ctrl-y` | ✅ |
| Indent / outdent (visual) | `<` / `>` (keeps selection) | `<` / `>` → `vim::Indent`/`Outdent` | ✅ |
| Move line up / down | `<A-k>` / `<A-j>` (n,i,v) | `alt-k` / `alt-j` (this config) | ✅ |
| Move buffer/tab left / right | `<A-h>` / `<A-l>` → BufferLineMove | `alt-h` / `alt-l` → `pane::SwapItem…` | ✅ |
| Multi-cursor | ⚠️ **none** — no multicursor plugin installed | `ctrl-d` `editor::SelectNext`; `shift-alt-up/down` `AddSelection…` | ⚠️ |
| Select all occurrences | ⚠️ nearest: `<leader>sw`, or `*` then `:%s` | `ctrl-shift-l` → `editor::SelectAllMatches` | ⚠️ |
| Split below / right | `<leader>-` / `<leader>|` | `pane::SplitDown/Right` exist; **unbound** (`ctrl-\` default SplitRight is overridden) | 🔧 |
| Close split | `<leader>wd` | unbound | 🔧 |
| Focus pane h/j/k/l | `<C-h/j/k/l>` | `ctrl-h/j/k/l` (this config) | ✅ |
| Zoom / maximise pane | `<leader>wm`, `<leader>uZ` | `workspace::ToggleZoom` — unbound | 🔧 |
| Terminal toggle | `<c-\>` (this config) | `ctrl-\` → `ToggleBottomDock`; default `ctrl-`` | ✅ |
| Terminal (new) | `<leader>ft` / `<leader>fT` | `ctrl-shift-t` → `workspace::NewTerminal` | 🔧 |
| Git status | `<leader>gs` (picker) | `space g g` → `git_panel::ToggleFocus` | ✅ |
| Git blame | `<leader>gb`, `<leader>ghb` | `space g b` → `git::Blame` | ✅ |
| Git diff / hunk preview | `<leader>gd`, `<leader>ghp` | `git::Diff`/`ToggleSelectedDiffHunks` — unbound | 🔧 |
| Hunk next / prev | `]h` / `[h` | **`] h` / `[ h` unbound** (`editor::GoToHunk` exists) | 🔧 |
| Stage / reset hunk | `<leader>ghs` / `<leader>ghr` | `git::ToggleStaged` / `git::Restore` — unbound | 🔧 |
| Git branches | `<leader>gb`… (via lazygit) | `space g x` → `git::Branch` | 🔧 |
| Lazygit | `<leader>gg` | `tasks.json` "Lazygit" task | ✅ (different mechanism) |
| AI / agent panel | ⚠️ **none** — no AI extra enabled | `space a c` → `agent::ToggleFocus` | ⚠️ |
| Jump list back / forward | `<C-o>` / `<C-i>` | `ctrl-o` / `ctrl-i` → `pane::GoBack`/`GoForward` (vim.json) | ✅ |
| Jump list picker | `<leader>sj` | unbound | 🔧 |
| Escape insert | `jk` (this config) | `j k` → `vim::NormalBefore` (this config) | ✅ *(nuance: nvim `<Esc>` moves cursor left, `NormalBefore` does not)* |
| Insert start/end of line | `<C-b>` / `<C-e>` | `ctrl-b` / `ctrl-e` (this config) | ✅ |
| Paste over selection keeping register | `x`-mode `p` remap | `["vim::Paste", {"preserve_clipboard": true}]` | ✅ |
| Soft wrap toggle | `<leader>uw` | `space u w` → `editor::ToggleSoftWrap` | ✅ |
| Inlay hints toggle | `<leader>uh` | `editor::ToggleInlayHints` — unbound | 🔧 |
| Line numbers toggle | `<leader>ul`, `<leader>uL` | ⚠️ no action; settings-only | ⚠️ |
| Markdown preview | — | `space m p` / `space m P` | Zed-only |
| Centered layout / zen | `<leader>uz` (snacks zen) | `space c z` → `ToggleCenteredLayout` | ✅ |
| Command palette | `<leader>sC`; `:` is a real cmdline | `:` (limited) — see §7 | ⚠️ |
| Harpoon marks | `<leader>h`, `<leader>H`, `<leader>1..5` | ⚠️ nearest: `pane::TogglePinTab` (`space b p`) | ⚠️ |

**Tally:** 33 already aligned, 22 trivially alignable, 8 structurally different.

---

## 5. Alignment: concrete proposal

Direction is stated per change. Guiding principle: **Zed is primary**, so nvim only moves when nvim is the odd one out; but where LazyVim's leader map is the more complete model (LSP verbs, git hunks, splits, symbols), **Zed moves toward nvim** — that is most of the work, because those operations are simply unbound in Zed today.

### 5a. Zed `keymap.json` — replace the two affected blocks

**Direction: Zed → nvim** (adopt LazyVim's leader vocabulary), plus fixes for Z1/Z3/Z4/Z6/Z8.

Replace the **first block** (`keymap.json:9-87`, context `Editor && vim_mode == normal && !VimWaiting && !menu`) `bindings` with:

```jsonc
{
  "context": "Editor && vim_mode == normal && !VimWaiting && !menu",
  "bindings": {
    // Leader must not fall through to vim::WrappingRight, or every
    // `space …` sequence waits 1s. https://zed.dev/docs/key-bindings#precedence
    "space": null,

    // Window movement
    "ctrl-h": "workspace::ActivatePaneLeft",
    "ctrl-l": "workspace::ActivatePaneRight",
    "ctrl-k": "workspace::ActivatePaneUp",
    "ctrl-j": "workspace::ActivatePaneDown",

    // General
    "ctrl-s": "workspace::Save",
    "space space": "file_finder::Toggle",
    "space f f": "file_finder::Toggle",
    "space f r": "projects::OpenRecent",
    "space f e": "pane::RevealInProjectPanel", // was `space e` (dead); LazyVim <leader>fe
    "space f n": "workspace::NewFile",         // LazyVim <leader>fn
    "space /": "pane::DeploySearch",
    "space s g": "pane::DeploySearch",
    "space s w": "pane::DeploySearch",         // nearest to LazyVim <leader>sw

    // Buffers / Tabs
    "shift-h": "pane::ActivatePreviousItem",
    "shift-l": "pane::ActivateNextItem",
    "space b b": "tab_switcher::Toggle",
    "space ,": "tab_switcher::Toggle",
    "space b d": "pane::CloseActiveItem",
    "space b o": "pane::CloseOtherItems",
    "space b p": "pane::TogglePinTab",
    "space b shift-p": ["pane::CloseAllItems", { "close_pinned": false }],

    // LSP — mirrors LazyVim's <leader>c* and g* map
    "g r": "editor::FindAllReferences",
    "g shift-i": "editor::GoToImplementation", // LazyVim gI (g i is vim::InsertAtPrevious)
    "g shift-k": "editor::ShowSignatureHelp",
    "space c r": "editor::Rename",             // LazyVim <leader>cr
    "space c a": "editor::ToggleCodeActions",  // LazyVim <leader>ca
    "space c d": "editor::Hover",              // nearest to LazyVim <leader>cd
    "space c f": "editor::Format",
    "space c s": "outline::Toggle",            // LazyVim <leader>cs / <leader>ss
    "space s s": "outline::Toggle",
    "space s shift-s": "project_symbols::Toggle", // LazyVim <leader>sS
    "space x x": "diagnostics::Deploy",

    // Diagnostics navigation
    "] e": ["editor::GoToDiagnostic", { "severity": "error" }],
    "[ e": ["editor::GoToPreviousDiagnostic", { "severity": "error" }],
    "] w": ["editor::GoToDiagnostic", { "severity": "warning" }],
    "[ w": ["editor::GoToPreviousDiagnostic", { "severity": "warning" }],

    // Git — mirrors LazyVim gitsigns
    "space g x": "git::Branch",
    "space g b": "git::Blame",
    "space g g": "git_panel::ToggleFocus",
    "space g s": "git_panel::ToggleFocus",       // LazyVim <leader>gs
    "space g h s": "git::ToggleStaged",          // LazyVim <leader>ghs
    "space g h r": "git::Restore",               // LazyVim <leader>ghr
    "space g h p": "editor::ToggleSelectedDiffHunks", // LazyVim <leader>ghp
    "] h": "editor::GoToHunk",                   // LazyVim ]h
    "[ h": "editor::GoToPreviousHunk",           // LazyVim [h

    // Windows / splits — LazyVim <leader>- and <leader>|
    "space -": "pane::SplitDown",
    "space |": "pane::SplitRight",
    "space w d": "pane::CloseAllItems",
    "space w m": "workspace::ToggleZoom",

    // Toggles
    "space u w": "editor::ToggleSoftWrap",
    "space u h": "editor::ToggleInlayHints",     // LazyVim <leader>uh
    "space u b": "editor::ToggleGitBlameInline",

    // Terminal / quit
    "space f t": "workspace::NewTerminal",       // LazyVim <leader>ft
    "space q q": "zed::Quit"                     // LazyVim <leader>qq
  }
}
```

Then in the **`Editor && VimControl && !menu`** block (`keymap.json:107-119`), **remove `"space e"`** and move `OpenExcerpts` off `g f`:

```jsonc
{
  "context": "Editor && VimControl && !menu",
  "bindings": {
    "p": ["vim::Paste", { "preserve_clipboard": true }],

    "alt-j": "editor::MoveLineDown",
    "alt-k": "editor::MoveLineUp",
    "alt-h": "pane::SwapItemLeft",
    "alt-l": "pane::SwapItemRight",

    "space e": "workspace::ToggleLeftDock" // keep exactly one `space e`
    // removed: "g f" override — restores vim's editor::OpenSelectedFilename
  }
}
```

And in the `(vim_mode == normal || vim_mode == visual)` block (`keymap.json:88-106`), replace `g f` with a free key:

```jsonc
      "g x": "editor::OpenExcerpts", // was `g f`, which shadowed vim's gf
```

**Delete entirely** (Z6) the visual-mode `g c` block at `keymap.json:131-137` — `vim.json` already provides `vim::ToggleComments` there.

**Optional (Z4):** if you want `Q` back for macro replay, drop `"shift-q": "pane::CloseActiveItem"` from the first block and rely on `space b d`. Neovim has no `Q`-closes-buffer binding, so dropping it *increases* alignment.

**Optional (Z9):** change `"ctrl-|"` to `"ctrl-shift-\\"` in the `Workspace || Editor || Terminal` block.

### 5b. Zed `settings.json` — remove the two dead keys

```diff
     "agent": {
         "sidebar_side": "right",
         "dock": "right",
         "default_model": {
             "enable_thinking": false,
             "provider": "copilot_chat",
             "model": "gpt-4.1"
-        },
-        "inline_assistant_model": {
-            "provider": "copilot_chat",
-            "model": "gpt-4o"
         }
     },
```
```diff
     "edit_predictions": {
         "provider": "zed",
-        "mode": "subtle",
-        "enabled_in_text_threads": false
+        "mode": "subtle"
     }
```

### 5c. Neovim `lua/config/keymaps.lua` — fixes N2 and N4

**Direction: nvim internal** (N2 is a genuine self-collision; N4 is robustness).

```lua
-- bufferline
map("n", "<A-l>", "<cmd>BufferLineMoveNext<cr>", { desc = "Move buffer to next" })
map("n", "<A-h>", "<cmd>BufferLineMovePrev<cr>", { desc = "Move buffer to previous" })
-- NOTE: <A-p> was here. LazyVim binds <a-p> buffer-locally to "Prev Reference" in
-- servers["*"].keys, which shadows it in every LSP buffer. Use a leader key instead.
map("n", "<leader>bP", "<cmd>BufferLinePick<cr>", { desc = "Pick a buffer" })

-- floating terminal.
-- LazyVim maps <c-/> and <c-_> for BOTH "n" and "t"
-- (lazyvim/config/keymaps.lua:195-196), so delete both modes.
-- pcall guards against LazyVim dropping these on a future update.
for _, lhs in ipairs({ "<c-/>", "<c-_>" }) do
  for _, mode in ipairs({ "n", "t" }) do
    pcall(vim.keymap.del, mode, lhs)
  end
end
map("n", "<c-\\>", function()
  Snacks.terminal(nil, { cwd = LazyVim.root() })
end, { desc = "Terminal (Root Dir)" })
map("t", "<c-\\>", "<cmd>close<cr>", { desc = "Hide Terminal" })
```

> **This is the documented way to remove a LazyVim default keymap.** Per https://www.lazyvim.org/configuration/general, `lua/config/keymaps.lua` is loaded automatically at the right time, and `LazyVim/lua/lazyvim/config/init.lua:294-300` loads `lazyvim.config.keymaps` *before* `config.keymaps` — so `vim.keymap.del` there always runs after the default was set. Do **not** use `LazyVim.safe_keymap_set` in your own config (`lazyvim/config/keymaps.lua:3-4`).
> For keymaps defined by a plugin's `keys` spec rather than `config/keymaps.lua`, the correct removal is `keys = { { "<lhs>", false } }` in your plugin spec, not `vim.keymap.del`.

### 5d. Neovim `lua/plugins/ui.lua` — fix N1 and drop N6

```lua
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    opts = {
      auto_enable = true,
      preview = {
        auto_preview = false,
        win_height = 12,
        win_vheight = 12,
        delay_syntax = 80,
      },
      func_map = {
        prevfile = "<c-p>", -- was "<c-p" — missing `>`
        nextfile = "<c-n>", -- was "<c-n" — missing `>`
      },
    },
  },
```

And in the lualine spec, delete the dead codeium line:

```diff
       table.remove(opts.sections.lualine_y, 1)
       opts.sections.lualine_z = {
         { progress },
       }
-
-      table.insert(opts.sections.lualine_x, 2, LazyVim.lualine.cmp_source("codeium"))
     end,
```

### 5e. Optional: give Neovim the multi-cursor / select-all-occurrences Zed has

**Direction: nvim → Zed.** This is the one place Zed's model is clearly more capable and nvim has no equivalent (see §7). If you want parity, add one plugin — `lua/plugins/multicursor.lua`:

```lua
return {
  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    keys = {
      -- mirrors Zed: ctrl-d = SelectNext, ctrl-shift-l = SelectAllMatches
      { "<C-d>", function() require("multicursor-nvim").matchAddCursor(1) end, mode = { "n", "x" }, desc = "Add Cursor at Next Match" },
      { "<C-S-l>", function() require("multicursor-nvim").matchAllAddCursors() end, mode = { "n", "x" }, desc = "Add Cursors to All Matches" },
      { "<M-Up>", function() require("multicursor-nvim").lineAddCursor(-1) end, mode = { "n", "x" }, desc = "Add Cursor Above" },
      { "<M-Down>", function() require("multicursor-nvim").lineAddCursor(1) end, mode = { "n", "x" }, desc = "Add Cursor Below" },
    },
    config = function()
      require("multicursor-nvim").setup()
      vim.keymap.set("n", "<Esc>", function()
        local mc = require("multicursor-nvim")
        if mc.hasCursors() then mc.clearCursors() else vim.cmd("noh") end
      end, { desc = "Clear cursors / hlsearch" })
    end,
  },
}
```

> ⚠️ Unlike everything else in this report, this plugin choice is **not** verified against a primary source (it is not a LazyVim extra and I did not check its current API). Treat the snippet as a starting point and check its README. Listed again in §8.

---

## 6. Alignment: behaviour settings proposal

Verified defaults. nvim column = LazyVim `lua/lazyvim/config/options.lua` unless the user overrides it; Zed column = `v1.12.1/assets/settings/default.json` unless overridden.

| Behaviour | Neovim (effective) | Zed (effective) | Aligned? | Change which side |
|---|---|---|---|---|
| Relative line numbers | `relativenumber = true` (LazyVim `:88`) — **always** relative | `relative_line_numbers` unset → **`"disabled"`**; `vim.toggle_relative_line_numbers = true` → relative in normal, absolute in insert | ❌ | **Neither is wrong — pick one.** Zed's hybrid model is the better one; move nvim to it (below) |
| Absolute number column | `number = true` (`:85`) | `gutter.line_numbers` default `true` | ✅ | — |
| `scrolloff` | `4` (LazyVim `:90`) | `vertical_scroll_margin` **`3`** | 🔧 | **Zed** → `4` |
| `sidescrolloff` | `8` (`:96`) | `horizontal_scroll_margin` (default `5`) | 🔧 | Zed → `8` (cosmetic) |
| Wrap | `wrap = false` (`:115`) | `soft_wrap` **`"none"`** | ✅ | — |
| Tab width | `tabstop = 2`, `shiftwidth = 2`, `expandtab` (`:62,93,106`) | `tab_size` **`4`**, `hard_tabs` default false | ❌ | **Zed** → `tab_size: 2` |
| Format on save | `vim.g.autoformat = false` (`options.lua:11`) | `format_on_save: "off"` | ✅ | — |
| Inlay hints | `inlay_hints.enabled = false` (`lsp.lua:5`) | `inlay_hints.enabled: false` | ✅ | — |
| Search: ignorecase + smartcase | `ignorecase = true`, `smartcase = true` (`:78,98`) | `use_smartcase_search: true` | ✅ | — |
| Search: `f`/`t` smartcase | n/a (vim `f` is case-sensitive) | `vim.use_smartcase_find` default `false` | ✅ | leave `false` to match vim |
| Search highlight | `hlsearch = false` (`options.lua:6`) | Zed always highlights matches; no equivalent off switch | ⚠️ | cannot align — §7 |
| Clipboard | `clipboard = "unnamedplus"` (`:57`, unless `SSH_CONNECTION`) | `vim.use_system_clipboard` default **`"always"`** | ✅ | — |
| Paste keeps register | `x`-mode `p` remap (`keymaps.lua:28`) | `["vim::Paste", {"preserve_clipboard": true}]` | ✅ | — |
| Whitespace rendering | `list = false` (`options.lua:8`, overriding LazyVim's `list = true`) | `show_whitespaces` default `"selection"` | 🔧 | **Zed** → `"none"` to match |
| Autosave | `autowrite = true` (`:54`) — writes on buffer switch | `autosave` default `"off"` | 🔧 | Zed → `{"after_delay":{"milliseconds":1000}}` *if* you want parity; `autowrite` is much weaker, so leaving Zed `off` is also defensible |
| Confirm on unsaved quit | `confirm = true` (`:60`) | Zed prompts by default | ✅ | — |
| Cursor line highlight | `cursorline = true` (`:61`) | `current_line_highlight` default `"all"` | ✅ | — |
| Scrollbar | n/a | `scrollbar.show: "never"` (user) | — | Zed-only preference |
| Leader key | `vim.g.mapleader = " "` (LazyVim `options.lua:2`) | `space` prefix in keymap **but bare `space` still bound** | ❌ | **Zed** → `"space": null` (Z8) |
| Local leader | `maplocalleader = "\\"` (`:3`) | no concept | ⚠️ | — |
| Which-key hints | which-key.nvim, `timeoutlen = 300` (`:108`) | no equivalent; 1s prefix timeout is fixed | ⚠️ | — |
| Command line | `cmdheight = 0` + noice **disabled** → broken (N3) | n/a | ❌ | **nvim** → `cmdheight = 1` or re-enable noice |
| Font | `guifont` FiraCode (neovide only) | `buffer_font_family: "FiraCode Nerd Font"` | ✅ | — |
| Theme | `tokyonight` (night) | `Ayu Dark` / `Gruvbox Light`, `mode: system` | ⚠️ | different themes by choice |
| File tree side | snacks explorer — left by default | `project_panel.dock: "left"` (default is `"right"`) | ✅ | already deliberately aligned |
| AI panel side | n/a | `agent.dock: "right"` | — | Zed-only |

### 6a. Zed `settings.json` — behaviour additions

```jsonc
{
  // ——— alignment with LazyVim options.lua ———
  "tab_size": 2,                    // LazyVim shiftwidth/tabstop = 2
  "vertical_scroll_margin": 4,      // LazyVim scrolloff = 4
  "horizontal_scroll_margin": 8,    // LazyVim sidescrolloff = 8
  "show_whitespaces": "none",       // matches vim.opt.list = false
  "relative_line_numbers": "enabled", // keep with vim.toggle_relative_line_numbers
  "vim": {
    "toggle_relative_line_numbers": true, // relative in normal, absolute in insert
    "use_system_clipboard": "always",     // == clipboard=unnamedplus (already default)
    "use_smartcase_find": false,          // vim's f/t are case-sensitive (already default)
    "highlight_on_yank_duration": 200     // already default
  }
}
```

### 6b. Neovim `lua/config/options.lua` — behaviour changes

```lua
-- N3: cmdheight=0 only works with a replacement message UI (noice), which is
-- disabled in lua/plugins/disabled.lua. Give the command line a line back.
vim.opt.cmdheight = 1

-- Match Zed's hybrid line numbers (relative in normal, absolute in insert),
-- which is the better model of the two. Zed does this via
-- vim.toggle_relative_line_numbers; Neovim needs an autocmd.
vim.opt.relativenumber = true
local relnum = vim.api.nvim_create_augroup("hybrid_relnum", { clear = true })
vim.api.nvim_create_autocmd("InsertEnter", {
  group = relnum,
  callback = function() vim.opt_local.relativenumber = false end,
})
vim.api.nvim_create_autocmd("InsertLeave", {
  group = relnum,
  callback = function() vim.opt_local.relativenumber = true end,
})
```

*(If you prefer nvim's always-relative behaviour, do the opposite instead: set `"vim": { "toggle_relative_line_numbers": false }` and `"relative_line_numbers": "enabled"` in Zed, and drop the autocmd.)*

---

## 7. What can't be aligned, and why

Every limitation below is cited, not asserted.

1. **Zed has no full vim command line.** https://zed.dev/docs/vim#command-palette states plainly: *"We don't emulate the full power of Vim's command line yet. In particular, commands currently do not support arguments."* So `:%s/a/b/g` with arguments, `:g/pat/norm`, `:!cmd`, ranges, and `:h` are not available. The documented ex-command surface is a fixed alias list (`:w`, `:j[oin]`, `:d[elete]`, `:s[ort]`, `:y[ank]`, and panel openers `:E`, `:G`, `:A`, `:te`, `:cl[ist]`, `:Ext`…). **Nothing to align — keep using nvim for heavy `:`-driven editing.**

2. **Neovim has no multibuffer.** Zed's `editor::OpenExcerpts` / `expand_excerpt_lines` / `double_click_in_multibuffer` (documented at https://zed.dev/docs/configuring-zed#double-click-in-multibuffer and `#expand-excerpt-lines`) present search or diagnostic results as a single **editable** buffer spanning many files. The nearest nvim equivalents — quickfix + `nvim-bqf` (installed) and `grug-far.nvim` (installed, search/replace) — are navigation and batch-replace tools, not one editable surface. **Structural; no binding fixes it.**

3. **Neovim has no multi-cursor.** Zed ships `editor::SelectNext` (`ctrl-d`), `editor::SelectAllMatches` (`ctrl-shift-l`), `editor::AddSelectionAbove/Below` (`shift-alt-up/down`) — all in `default-linux.json:539-553`. No multicursor plugin is installed in this nvim config, and LazyVim has no multicursor extra enabled. Closest native workflows are `:%s`, macros (`q`), and visual-block `I`/`A`. §5e offers an opt-in plugin, but the *idioms* stay different (vim leans on operators + macros; Zed on simultaneous carets).

4. **Zed's quickfix analogue is not a quickfix list.** LazyVim's `<leader>xq` / `]q` / `[q` / `<leader>xl` and `nvim-bqf` have no Zed counterpart; Zed uses the diagnostics panel (`diagnostics::Deploy`) and project-search multibuffers. Aligned *conceptually* in the table, not by key.

5. **No harpoon in Zed.** `lazyvim.plugins.extras.editor.harpoon2` gives `<leader>h`, `<leader>H`, `<leader>1..5` (`extras/editor/harpoon2.lua:15,22,32-33`). Zed's nearest is pinned tabs (`pane::TogglePinTab`, bound to `space b p`), which has no numeric direct-jump. Structurally different.

6. **`hlsearch = false` has no Zed equivalent.** `use_smartcase_search`, `seed_search_query_from_cursor` and `vim.use_regex_search` exist in `default.json`, but there is no setting to suppress match highlighting. nvim's `options.lua:6` preference cannot be mirrored.

7. **Which-key has no Zed counterpart.** LazyVim's discoverable leader popup (`timeoutlen = 300`) is not reproducible: Zed's prefix behaviour is a fixed *1 second* wait with no menu, per https://zed.dev/docs/key-bindings#precedence. Deep `space g h s`-style chords are therefore noticeably less pleasant in Zed than in nvim — a real reason to keep Zed's leader map shallower than LazyVim's.

8. **`localleader` doesn't exist in Zed.** LazyVim uses `\` (`lazyvim/config/options.lua:3`) for filetype-local maps such as `<localleader>r` (`keymaps.lua:215`). Zed has no per-language leader; use language-scoped contexts if needed.

9. **Toggle-style UI options differ in kind.** LazyVim exposes ~18 runtime `Snacks.toggle` bindings under `<leader>u` (`keymaps.lua:145-165`) for spell, wrap, conceal, treesitter, dim, animate, indent guides, etc. Zed has actions for only some of these (`editor::ToggleSoftWrap`, `editor::ToggleInlayHints`, `editor::ToggleGitBlameInline` — all verified valid); the rest are settings-file-only, with no action to bind. Partial alignment only, as reflected in §5a.

10. **`vim.g.ai_cmp` / AI completion story is asymmetric.** Zed has first-party `edit_predictions` and an agent panel; this nvim config enables no AI extra at all, so `<leader>a*` has nothing to bind. Aligning would mean adding an nvim AI extra — a scope decision, not a keybinding one.

---

## 8. Unverified / needs user confirmation

1. **`ctrl-|` reachability** (Z9). Zed's syntax rules permit the literal codepoint, but I did not confirm the platform reports `ctrl-|` rather than `ctrl-shift-\`. Test by pressing it; if dead, use `"ctrl-shift-\\"`.
2. **`lsp.vtsls.enable_lsp_tasks`** is a valid key, but `default.json:2530` describes it as *"A special flag for **rust-analyzer** integration, to use server-provided tasks"*. Whether vtsls surfaces LSP tasks at all is unverified — it may be a harmless no-op.
3. **The replacement for `agent.inline_assistant_model`** (Z2). I confirmed the key is gone in 1.12.1 but did not find a documented successor for choosing a *separate* inline-assist model. It may simply no longer be configurable, using `agent.default_model` instead. Check the Zed 1.x agent release notes if the distinct gpt-4o inline model matters to you.
4. **`enabled_in_text_threads`** (Z5) — confirmed absent from 1.12.1; I did not trace which release removed it or whether a renamed key exists.
5. **`<C-e>` / `<C-b>` insert-mode maps vs blink.cmp** (`keymaps.lua:7-8`). blink's keymap presets commonly bind `<C-e>` to *hide menu*. I did not inspect the resolved blink preset in this config, so which wins while the completion menu is open is unverified. Test with the menu open.
6. **`vim.g.neovide_transparency`** (`options.lua:23`). Neovide renamed this to `neovide_opacity` at some point; Neovide is not installed here so I could not check the installed version. Harmless either way (unknown `vim.g` values are inert).
7. **The multicursor plugin in §5e** is the only unsourced recommendation in this report — not a LazyVim extra, API not verified.
8. **`<leader>sS` (project symbols)** — I verified `<leader>ss` directly in `extras/editor/snacks_picker.lua:151`; `<leader>sS` for *workspace* symbols is taken from the LazyVim keymaps documentation and this config's own comments (`keymap.json:53`), not from a line I read in source.
9. **Runtime keymap probe was partial.** `nvim --headless -c 'doautocmd User VeryLazy'` confirmed the global `<M-p>`/`<M-h>`/`<M-l>` maps, but buffer-local LSP maps only attach on a real `LspAttach`, so the N2 collision is proven from source (`snacks/keymap.lua:89` + `servers["*"].keys`) rather than observed. Confirm interactively with `:verbose nmap <A-p>` inside a TypeScript buffer.
10. **Zed log inspection was inconclusive.** `~/.local/share/zed/logs/Zed.log` contains no keymap or settings parse errors, but the log had rotated to mostly LSP/telemetry lines, so absence of errors there is weak evidence. The schema comparison in §3 is the stronger signal.

---

## 9. Sources

### Local primary sources
- `/home/raven/.config/nvim/` — `init.lua`, `lazyvim.json`, `lazy-lock.json`, `.neoconf.json`, `stylua.toml`, `debug.lua`, `lua/config/{lazy,options,keymaps,autocmds}.lua`, `lua/plugins/{coding,dap,disabled,editor,lsp,themes,treesitter,ui}.lua`
- `/home/raven/.config/zed/` — `settings.json`, `keymap.json`, `tasks.json`, `snippets/javascript.json`, `themes/.keep`
- `/home/raven/.local/share/nvim/lazy/LazyVim/` @ v16.0.0 (`c10948c5`) — `lua/lazyvim/config/{init,keymaps,options}.lua`; `lua/lazyvim/plugins/{init,editor,ui,treesitter,colorscheme}.lua`; `lua/lazyvim/plugins/lsp/{init,keymaps}.lua`; `lua/lazyvim/util/lualine.lua`; `lua/lazyvim/plugins/extras/editor/{snacks_picker,snacks_explorer,harpoon2,leap,telescope}.lua`
- `/home/raven/.local/share/nvim/lazy/snacks.nvim/lua/snacks/keymap.lua` (buffer-local LSP keymaps)
- `/home/raven/.local/share/nvim/lazy/lazy.nvim/` @ v11.17.5 (`85c7ff37`)
- `/home/raven/.local/share/zed/{extensions/installed,languages,logs/Zed.log}`
- `/home/raven/.local/share/chezmoi/dot_config/{nvim,zed}/` (config source of truth)
- `/home/raven/.local/share/nvim/mason/packages/`

### Zed source @ tag `v1.12.1` (matching the installed build)
- `https://raw.githubusercontent.com/zed-industries/zed/v1.12.1/assets/settings/default.json`
- `https://raw.githubusercontent.com/zed-industries/zed/v1.12.1/assets/keymaps/default-linux.json`
- `https://raw.githubusercontent.com/zed-industries/zed/v1.12.1/assets/keymaps/vim.json`
- `https://raw.githubusercontent.com/zed-industries/zed/v1.12.1/crates/editor/src/actions.rs`
- `https://raw.githubusercontent.com/zed-industries/zed/v1.12.1/crates/project/src/project_settings.rs`
- `https://raw.githubusercontent.com/zed-industries/zed/v1.12.1/crates/workspace/src/pane.rs`

### Documentation
- https://zed.dev/docs/key-bindings (precedence, keystroke syntax, disabling with `null`)
- https://zed.dev/docs/vim (vim settings table, ex commands, supported plugins, core settings for vim mode)
- https://zed.dev/docs/configuring-zed (relative_line_numbers, multibuffer settings)
- https://zed.dev/docs/configuring-languages (workspace symbol search)
- https://zed.dev/docs/all-actions + `all-actions.md` (1381 action names — action-name validation)
- https://www.lazyvim.org/configuration/general (config file load timing)
- https://www.lazyvim.org/keymaps (keymap reference)

### Commands run (read-only)
`nvim --version`; `zed --version`; `nvim --headless +qa`; `nvim --headless -c 'checkhealth lazy' …`; `nvim --headless` spec-vs-lock diff (`lazy.core.config`); `nvim --headless -c 'doautocmd User VeryLazy'` keymap probe; `git -C …/LazyVim describe --tags`; JSONC parse + schema diff of `settings.json`/`keymap.json` against `default.json`; action-name set comparison. No file in either config directory was modified.
