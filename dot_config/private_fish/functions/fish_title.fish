function fish_title \
    --description "Set title to current folder and shell name" \
    --argument-names last_command

    set --local current_folder (basename (pwd))
    set --local current_command (status current-command 2>/dev/null; or echo $_)[1]
    set --local separator "|"

    set --local prompt "$current_folder: $last_command $separator $current_command"

    if test -z "$last_command"
        set prompt "$current_folder $separator $current_command"
    end

    echo $prompt
end
