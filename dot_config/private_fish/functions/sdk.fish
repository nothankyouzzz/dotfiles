# Wrapper function for SDKMAN!
#
# This stays lazy on purpose. Startup only needs SDKMAN_DIR for completions;
# the heavier Bash bridge is initialized the first time `sdk` is actually used.

function __sdkman_init_path
    echo "$SDKMAN_DIR/bin/sdkman-init.sh"
end

function __sdkman_noexport_init_path
    echo "$__fish_config_dir/functions/__sdkman-noexport-init.sh"
end

function __sdkman_ensure_noexport_init
    set -l sdkman_init (__sdkman_init_path)
    if not test -f "$sdkman_init"
        return 1
    end

    set -l sdkman_noexport_init (__sdkman_noexport_init_path)
    if not test -f "$sdkman_noexport_init"; or test "$sdkman_init" -nt "$sdkman_noexport_init"
        command mkdir -p (dirname "$sdkman_noexport_init")
        sed -E -e 's/^(\s*).*(export|to_path).*$/\1:/g' "$sdkman_init" >"$sdkman_noexport_init"
    end

    echo "$sdkman_noexport_init"
end

function __sdkman_run_in_bash --argument-names script
    set -l pipe (mktemp)
    bash -c "$script;
             echo -e \"\$?\" > $pipe;
             env | grep -e '^SDKMAN_\|^PATH' >> $pipe;
             env | grep -i -E \"^(`echo \${SDKMAN_CANDIDATES_CSV} | sed 's/,/|/g'`)_HOME\" >> $pipe;
             echo \"SDKMAN_OFFLINE_MODE=\${SDKMAN_OFFLINE_MODE}\" >> $pipe;
             echo \"SDKMAN_ENV=\${SDKMAN_ENV}\" >> $pipe"

    set -l bash_dump (cat "$pipe")
    command rm -f "$pipe"

    set -l sdk_status $bash_dump[1]
    set -l bash_env $bash_dump[2..-1]

    if test "$sdk_status" = 0
        for line in $bash_env
            set -l parts (string split "=" "$line")
            set -l var $parts[1]
            set -l value (string join "=" $parts[2..-1])

            switch "$var"
                case PATH
                    set value (string split : "$value")
            end

            if test -n "$value"
                set -gx $var $value
            end
        end
    end

    return $sdk_status
end

function sdk -d "Manage SDKs"
    set -q SDKMAN_DIR; or set -gx SDKMAN_DIR "$HOME/.sdkman"
    set -l sdkman_init (__sdkman_init_path)

    if not test -f "$sdkman_init"
        function read_confirm
            while true
                read -l -P "$argv[1] [y/N] " confirm

                switch $confirm
                    case Y y
                        return 0
                    case '' N n
                        return 1
                end
            end
        end

        if read_confirm "You don't seem to have SDKMAN! installed. Install now?"
            if not command -sq curl
                echo "curl required"
                return 1
            end

            if not command -sq bash
                echo "bash required"
                return 1
            end

            curl -s "https://get.sdkman.io" | bash | sed '/All done!/q'
            echo "Please open a new terminal/shell to load SDKMAN!"
        end

        return 1
    end

    set -l sdkman_noexport_init (__sdkman_ensure_noexport_init)
    or return 1

    set -l sdk_command (string join " " sdk (string escape -- $argv))
    __sdkman_run_in_bash "source \"$sdkman_noexport_init\" && $sdk_command"
end
