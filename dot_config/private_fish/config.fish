alias lvim="NVIM_APPNAME=nvim-lazy nvim"
alias avim="NVIM_APPNAME=nvim-astro nvim"

source ~/.config/fish/themes/tokyonight_moon.fish

function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

function update
  sudo snap refresh
  sudo apt update
  sudo apt full-upgrade
  sudo apt autoremove
end

# shell hooks
fzf --fish | source
zoxide init fish | source
conda "shell.fish" hook | source
direnv hook fish | source

set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME
set -gx PATH $HOME/.cabal/bin /home/nothankyou/.ghcup/bin $PATH # ghcup-env
