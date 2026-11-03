## Machines

Run `hostname` to see which machine you are on; reach the others with `ssh <alias>`, using the aliases as written (the safety hook blocks reading `~/.ssh/config`).

| Alias | Hostname | Notes |
|---|---|---|
| `wsl` | `fedora-pc` | Fedora 44 in WSL on the Windows desktop; hosts the homelab and the dev setup. The default target |
| `pc` | `n3o-pc1` | Windows 11 host of `wsl`. Rarely needed; do the work on `wsl` instead of SSHing here |
| `laptop` | `fedora` | Fedora laptop |
| `mini` | `n3o-macmini.local` | Mac mini (macOS) |

## Tools over SSH

A non-interactive `ssh <host> '<cmd>'` gets a bare PATH: no mise Node tools (`opencode`, etc., under `~/.local/share/mise/installs/node/<version>/bin`) and no `~/.local/bin` (`chezmoi`).

- Mise tools: run through an interactive shell, `ssh laptop 'zsh -ic "opencode plugin list"'`. Its `can't change option: zle` lines are harmless.
- `chezmoi` alone: `ssh <host> 'PATH=$HOME/.local/bin:$PATH chezmoi ...'`.
