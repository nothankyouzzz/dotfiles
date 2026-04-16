# Dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/). This repo is primarily for rebuilding my own environment quickly, keeping shell and CLI tooling reproducible, and separating a few pieces of machine-specific or private config from the rest.

The current setup is centered on `fish`, `git`, `starship`, `gdb`, MIME associations, and a separate WezTerm config that is pulled in as an external repo.

## Managed Config

- `dot_config/private_fish/`: `fish` shell config and plugin list
- `dot_gitconfig`: shared Git config, with local overrides loaded from `~/.gitconfig.local`
- `dot_config/starship.toml`: shell prompt config
- `dot_gdbinit` and `dot_gdb-dashboard`: GDB setup
- `dot_config/mimeapps.list`: MIME application associations
- `dot_codex/`: Codex-related config

## Bootstrap

Install `chezmoi` and the tools this repo assumes you already want on the machine, then initialize and apply:

```sh
chezmoi init git@github.com:nothankyouzzz/dotfiles.git
chezmoi apply
```

This setup is mainly tuned for my own Linux/WSL-style environment with `fish` as the interactive shell.

## Layout

This repo uses standard chezmoi naming:

- `dot_*`: files that will be written into `$HOME` with the leading dot restored
- `private_*`: files that should stay private or machine-specific
- `.chezmoiexternal.toml`: external resources managed by chezmoi
- `.chezmoiignore`: files in the source repo that should not be written to the target home directory

`README.md` is intentionally listed in `.chezmoiignore` so it stays repository-only and is not applied into `$HOME`.

## External Config

`~/.config/wezterm` is not stored inline in this repo. It is managed through `.chezmoiexternal.toml` as a separate git repo:

- `https://github.com/nothankyou/wezterm-config`

That keeps the terminal config versioned independently while still letting chezmoi materialize it into the target home directory.

## Secrets And Local Overrides

This repo expects some config to remain local:

- `~/.gitconfig.local` is included from the main Git config for machine- or identity-specific settings
- `private_*` files are where sensitive or non-portable config should live inside chezmoi source state

There is no broader secret-management workflow documented here yet. If that changes, it should be documented explicitly instead of implied.

## Workflow

Common day-to-day commands:

```sh
# Open the source directory
chezmoi cd

# Preview changes before writing to $HOME
chezmoi diff

# Apply the current source state
chezmoi apply

# Re-add an edited file from $HOME back into chezmoi source state
chezmoi add ~/.gitconfig

# Pull repo changes and apply them
chezmoi update

# Force a refresh of externals such as the wezterm repo
chezmoi apply --refresh-externals=always
```

## Notes

- `fish_plugins` currently uses `fisher` plugins, including `tokyonight-fish` and `nvm.fish`
- The `fish` config assumes several tools are installed separately, including `fzf`, `zoxide`, `direnv`, `starship`, `wezterm`, and `codex`
- This repo is optimized for my own machines first; portability is secondary
