# My Dotfiles

<!--toc:start-->
- [My Dotfiles](#my-dotfiles)
  - [Overview](#overview)
  - [Highlights](#highlights)
  - [Repository Layout](#repository-layout)
  - [Neovim Configurations](#neovim-configurations)
    - [LazyVim (`nvim-lazy`)](#lazyvim-nvim-lazy)
    - [AstroNvim (`nvim-astro`)](#astronvim-nvim-astro)
  - [Service & Automation](#service-automation)
  - [Bootstrap with ChezMoi](#bootstrap-with-chezmoi)
  - [Post-Install Notes](#post-install-notes)
<!--toc:end-->

This repository contains the configuration that backs my workstation. Everything
is managed by [`chezmoi`](https://www.chezmoi.io/) so it can be safely applied
across machines.

## Overview

- `fish` shell with `starship`, `zoxide`, `direnv`, and `conda` integration.
- Two opinionated Neovim profiles (`nvim-lazy`, `nvim-astro`) launched via the
  `lvim` and `avim` helper aliases.
- Terminal ergonomics via `zellij`, `btop`, and a curated prompt theme.
- Tooling glue for AI assistants (`codex`, `Gemini`, `mcphub`) and automation.

## Highlights

- **Shell experience:** `dot_config/private_fish/` holds the runtime config,
  including theme sourcing, API key loading, and helper functions such as
  `update.fish`.
- **Prompts:** `dot_config/starship.toml` customizes the Starship prompt to match
  the Fish theme.
- **Package management:** `dot_condarc` pins defaults for Conda environments;
  `dot_config/direnv/direnvrc` adds a minimal `use_conda` helper.
- **Git:** `dot_gitconfig` ships ready-to-use identity, aliases, and default
  tooling.
- **Debugging:** `dot_gdbinit` wires up the bundled `dot_gdb-dashboard` for an
  enhanced TUI experience.
- **AI tooling:** `dot_codex/private_config.toml` and
  `dot_gemini/settings.json` store editor preferences and model defaults.

## Repository Layout

- `dot_config/nvim-lazy/` - LazyVim-based profile with grouped plugin specs
  under `lua/plugins`.
- `dot_config/nvim-astro/` - AstroNvim setup with lockfiles and custom
  per-plugin modules.
- `dot_config/nvim/` - Vanilla Neovim space for lightweight tweaks when the full
  profiles are unnecessary.
- `dot_config/private_fish/` - Fish shell config, completions, helper
  functions, and the Tokyo Night theme.
- `dot_config/systemd/user/` - User services; `chroma.service` keeps a local
  ChromaDB instance alive.
- `dot_config/zellij/config.kdl` - Tmux-like keymaps, floating panes, and plugin
  bindings for the terminal multiplexer.
- `dot_config/btop/btop.conf` - Tokyo Storm theme and monitor defaults for
  `btop`.
- `dot_config/mcphub/servers.json` - MCP server definitions consumed by
  `mcphub`.
- `dot_config/mimeapps.list` - Default application mappings for the desktop.
- Other top-level files: `dot_gdbinit`, `dot_gdb-dashboard`, `dot_condarc`, and
  `README.md`.

## Neovim Configurations

Neovim acts as the primary editor. Launch `nvim` with `NVIM_APPNAME` to select a
profile or use the Fish aliases provided.

### LazyVim (`nvim-lazy`)

- Plugin groups under `lua/plugins/{ai,lang,ui,utils}` keep the configuration
  modular.
- Language focus on Haskell and Python via dedicated modules.
- Includes productivity helpers such as `competitest`, `snacks`, `neo-tree`, and
  UI polish (`bufferline`, `edgy`).
- AI integrations (`codecompanion`, `sidekick`, `avante`) hook into local and
  remote assistants.

### AstroNvim (`nvim-astro`)

- Extends AstroNvim via `lua/plugins/*.lua` overrides and lockfiles.
- Adds `blink.cmp`, `flash`, `none-ls`, `treesitter`, and custom lint/format
  settings.
- `neovim.yml` tracks the bootstrap packages needed on new machines.

## Service & Automation

- `dot_config/systemd/user/chroma.service` runs `chroma` under `systemd --user`,
  using `default.target.wants/symlink_chroma.service` to auto-enable it.
- `dot_config/mcphub/` and `dot_config/private_fish/functions/` provide helper
  scripts for server management and quick session setup.

## Bootstrap with ChezMoi

```bash
chezmoi init https://github.com/nothankyou/dotfiles
chezmoi apply
```

Use `chezmoi apply --dry-run` first if you want to inspect changes, or
`chezmoi cd` to drop into the working tree.

## Post-Install Notes

- Install prerequisites: `fish`, `starship`, `zellij`, `direnv`, `zoxide`,
  `chezmoi`, `conda`, and `neovim`.
- Some files (`private_fish/api_keys.fish`) are expected to exist locally but
  are not tracked; create them with your own secrets.
- Enable the Chroma service with `systemctl --user enable --now chroma.service`
  after ensuring `chroma` is installed.
