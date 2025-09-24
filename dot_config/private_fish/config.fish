# Aliases
alias lvim="NVIM_APPNAME=nvim-lazy nvim"
alias avim="NVIM_APPNAME=nvim-astro nvim"

# Theme
source ~/.config/fish/themes/tokyonight_moon.fish

# API Keys
source ~/.config/fish/api_keys.fish

# Environment variables
set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME
set -gx PATH $HOME/.cabal/bin /home/nothankyou/.ghcup/bin $PATH # ghcup-env

# Shell hooks
fzf --fish | source
zoxide init fish | source
conda "shell.fish" hook | source
direnv hook fish | source
starship init fish | source
