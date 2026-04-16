function fish_title \
    --description "Set title to the foreground command or current folder"

    set --local title (path basename -- $PWD)

    if set --query argv[1]
        set --local command_line (string trim -- $argv[1])

        if test -n "$command_line"
            set --local command_parts (string split --max 1 ' ' -- $command_line)
            set title (path basename -- $command_parts[1])
        end
    end

    echo $title
end
