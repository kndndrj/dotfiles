# Andrej's Arch Linux dotfiles
Various config files for different programs or utilities for Arch. I find that "GNU stow" works best for me at managing my dotfiles, it's just a simple utility for managing symlinks on the system.

## How to use
1. Clone this repository
2. Install GNU stow:
```bash
pacman -S stow
```
3. Run ```stow``` (the following command assumes that you are one level above *this* directory)
```bash
stow -t $HOME/ dotfiles
```
