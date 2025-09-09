# My Dotfiles

This repository contains my personal dotfiles for various command-line tools and applications. The configurations are managed using a dotfile manager, likely `chezmoi`.

## Overview

This setup includes configurations for:

- **Shell:** `fish` with `starship` prompt and `zoxide` for directory navigation.
- **Version Control:** `git` with user information pre-configured.
- **Package Management:** `conda` for Python environments.
- **Editor:** Neovim with two separate configurations:
  - `nvim-lazy`: A LazyVim-based setup.
  - `nvim-astro`: An AstroNvim-based setup.
- **Other Tools:**
  - `bottom`: A system monitor.
  - `direnv`: For directory-specific environments.
  - `mcphub`: A Minecraft server manager.

## Structure

- `dot_gitconfig`: Git configuration.
- `dot_condarc`: Conda configuration.
- `dot_config/starship.toml`: Starship prompt configuration.
- `dot_config/private_fish/`: Fish shell configuration, including aliases, theme, and environment variables.
- `dot_config/nvim-lazy/`: LazyVim configuration for Neovim.
- `dot_config/nvim-astro/`: AstroNvim configuration for Neovim.

## Neovim Setups

### LazyVim (`nvim-lazy`)

Activated with `lvim`. This configuration includes plugins for:

- AI-assisted coding (`codecompanion`, `mcphub`, `vectorcode`).
- Language support for Haskell and Python.
- UI enhancements like `bufferline`, `edgy`, and `neo-tree`.
- Utility plugins like `competitest` and `fzf`.

### AstroNvim (`nvim-astro`)

Activated with `avim`. This configuration includes plugins for:

- AI integration.
- Core AstroNvim features (`astrocore`, `astrolsp`, `astroui`).
- Additional plugins like `blink`, `flash`, `mason`, and `treesitter`.

## Installation

These dotfiles are likely managed by a tool like `chezmoi`. To use them, you would typically initialize `chezmoi` with this repository.

```bash
chezmoi init https://github.com/nothankyou/dotfiles
```

Then, apply the dotfiles:

```bash
chezmoi apply
```
