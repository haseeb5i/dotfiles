# Dotfiles Notes for Agents

## Vorssaint (macOS only)

- Vorssaint reads `~/.config/vorssaint/settings.plist` on every launch and never writes to it automatically. Any key in this file overrides UI changes on the next launch.
- Managed in chezmoi at `dot_config/vorssaint/settings.plist` (ignored on non-`darwin` hosts in `.chezmoiignore`).
- To save updated UI settings back to chezmoi, re-export and re-add:

```sh
/Applications/Vorssaint.app/Contents/MacOS/Vorssaint --export-settings ~/.config/vorssaint/settings.plist && chezmoi re-add ~/.config/vorssaint/settings.plist
```

- Full exports include text snippets if configured; review diffs before committing.
