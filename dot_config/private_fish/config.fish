# Environment
if test -r $__fish_config_dir/api_keys.fish
    source $__fish_config_dir/api_keys.fish
end

set -q BROWSER; or set -gx BROWSER wslview
set -q EDITOR; or set -gx EDITOR "env NVIM_APPNAME=nvim-lazy nvim"
set -q nvm_default_version; or set -g nvm_default_version v25.1.0
set -q PNPM_HOME; or set -gx PNPM_HOME "$HOME/.local/share/pnpm"
set -q SDKMAN_DIR; or set -gx SDKMAN_DIR "$HOME/.sdkman"

# Keep user-managed toolchains ahead of distro packages.
fish_add_path -gPm \
    $PNPM_HOME \
    $HOME/.local/bin \
    $HOME/.miniconda/condabin \
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
    if test -x $HOME/.local/bin/fzf
        $HOME/.local/bin/fzf --fish | source
    end

    if type -q zoxide
        zoxide init fish | source
    end

    if type -q direnv
        direnv hook fish | source
    end

    if type -q starship
        starship init fish | source
    end
end
