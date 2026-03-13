function conda --description 'Conda package and environment manager'
    set -l conda_exe $HOME/.miniconda/bin/conda
    if not test -x $conda_exe
        echo "conda: executable not found at $conda_exe" >&2
        return 127
    end

    if test (count $argv) -eq 0
        $conda_exe
        return $status
    end

    set -l cmd $argv[1]
    set -l rest $argv[2..-1]

    switch $cmd
        case activate deactivate reactivate
            set -l hook_code ($conda_exe shell.fish $cmd $rest | string collect)
            set -l hook_status $status
            if test $hook_status -ne 0
                return $hook_status
            end

            eval $hook_code
            # Conda's fish snippets start with `set -e` cleanups that return 4 when
            # the variables are unset. Activation still succeeds, so normalize this.
            return 0

        case install update upgrade remove uninstall
            $conda_exe $cmd $rest
            set -l conda_status $status

            if test $conda_status -eq 0
                set -l hook_code ($conda_exe shell.fish reactivate | string collect)
                if test $status -eq 0
                    eval $hook_code
                end
            end

            return $conda_status

        case '*'
            $conda_exe $cmd $rest
            return $status
    end
end
