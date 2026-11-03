## Machines

Run `hostname` to see which of these machines you are on; reach the others with `ssh <alias>`.

| Alias | Hostname | Notes |
|---|---|---|
| `wsl` | `fedora-pc` | Fedora 44 in WSL on the Windows desktop (`n3o-pc1`); hosts the homelab and the dev setup. Use this one |
| `pc` | `n3o-pc1` | Windows 11 host of `wsl`. Rarely used; don't SSH here, use `wsl` |
| `laptop` | `fedora` | Fedora laptop |
| `mini` | `n3o-macmini.local` | Mac mini (macOS) |

Use the aliases directly. Don't read `~/.ssh/config` to look them up; the safety hook blocks it.

## mise environment

Node tools (`opencode`, etc.) come from mise: `~/.local/share/mise/installs/node/<version>/bin`. `chezmoi` is in `~/.local/bin`. A non-interactive `ssh <host> '<cmd>'` has neither on its PATH.

- Run tools over SSH through an interactive shell: `ssh laptop 'zsh -ic "opencode plugin list"'`. The `can't change option: zle` lines it prints are harmless.
- For `chezmoi` alone, `ssh <host> 'PATH=$HOME/.local/bin:$PATH chezmoi ...'` is enough.
