# Separated from pure-fish/pure
function fish_title \
    --description "Set title to current folder and shell name"

    set --local current_folder (basename (pwd))
    set --local current_command (status current-command 2>/dev/null; or echo $_)[1]
    set --local separator "|"

    set --local prompt "$current_folder $separator $current_command"
    echo $prompt
end
