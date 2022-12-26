# Personal Dotfiles

- install [chezmoi](https://www.chezmoi.io/install/) and make sure it is available in `$PATH`
- initialize chezmoi with these dotfiles
```
chezmoi init https://github.com/xCodeR01/dotfiles.git 
```
- see what changes chezmoi would make 
```
chezmoi diff
```
- apply all or partial dotfiles (pass --dry-run or -n to see changes without applying)
```
chezmoi apply -v
chezmoi apply ~/.config/zsh -v
```
- see more help for chezmoi [here](https://www.chezmoi.io/user-guide/command-overview/)
