## Machines

Run `hostname` to see which machine you are on (`wsl` has no `hostname` command: use `cat /etc/hostname`). Reach the others with `ssh <alias>`, using the aliases as written (the safety hook blocks reading `~/.ssh/config`). All of them share one key, so any machine can reach the others.

| Alias | Hostname | Notes |
|---|---|---|
| `wsl` | `fedora-wsl` | Fedora 44 in WSL on the Windows desktop, user `raven` |
| `macbook` | `n3o-lap2.local` | MacBook Pro (Apple M5, macOS), user `raven` |

Over SSH there is no TTY, so `chezmoi apply` fails when a live file differs from chezmoi's last write. Check `chezmoi diff`, then apply named files with `--force`.
