set -gx BROWSER wslview
set -gx EDITOR nvim
set -g BUN_INSTALL "$HOME/.bun"
set -g nvm_default_version lts/krypton
set -g fish_greeting

fish_add_path -gPm \
    $BUN_INSTALL/bin \
    $HOME/.local/bin \
    $HOME/.cargo/bin \
    $HOME/.cabal/bin \
    $HOME/.ghcup/bin

if status is-interactive
    set -g fish_key_bindings fish_vi_key_bindings
end
