set -q BROWSER; or set -gx BROWSER wslview
set -q EDITOR; or set -gx EDITOR "env NVIM_APPNAME=nvim-lazy nvim"
set -q BUN_INSTALL; or set -gx BUN_INSTALL "$HOME/.bun"

fish_add_path -gPm \
    $BUN_INSTALL/bin \
    $HOME/.local/bin \
    $HOME/.cargo/bin \
    $HOME/.cabal/bin \
    $HOME/.ghcup/bin

if status is-interactive
    # Editing
    set -g fish_key_bindings fish_vi_key_bindings

    # Aliases
    alias lvim="NVIM_APPNAME=nvim-lazy nvim"
    alias avim="NVIM_APPNAME=nvim-astro nvim"

    # Shell integrations
    fzf --fish | source
    zoxide init fish | source
    direnv hook fish | source
    starship init fish | source
    wezterm shell-completion --shell fish | source
    codex completion fish | source
end
