## Machines

Run `hostname` to see which machine you are on (`wsl` has no `hostname` command: use `cat /etc/hostname`). Reach the others with `ssh <alias>`, using the aliases as written (the safety hook blocks reading `~/.ssh/config`). All three share one key, so any machine can reach the others.

| Alias | Hostname | Notes |
|---|---|---|
| `wsl` | `fedora-pc` | Fedora 44 in WSL on the Windows desktop, user `raven` |
| `macbook` | `n3o-lap2.local` | MacBook Pro (Apple M5, macOS), user `raven` |
| `mini` | `n3o-macmini.local` | Mac mini (Apple M4, macOS), user `raven` |

## Tools over SSH

A non-interactive `ssh <host> '<cmd>'` gets a bare PATH: no mise Node tools (`opencode`, etc., under `~/.local/share/mise/installs/node/<version>/bin`) and no Homebrew on `macbook`.
- Mise tools: run through an interactive shell, `ssh macbook 'zsh -ic "opencode plugin list"'`. Its `can't change option: zle` lines are harmless.
- `chezmoi`: in `~/.local/bin`, already on the bare PATH on `mini` and `wsl`; on `macbook` it is `/opt/homebrew/bin/chezmoi`: `ssh macbook 'PATH=/opt/homebrew/bin:$PATH chezmoi ...'`.
- Over SSH there is no TTY, so `chezmoi apply` fails when a live file differs from chezmoi's last write. Check `chezmoi diff`, then apply named files with `--force`.
