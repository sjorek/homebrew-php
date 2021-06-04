#!/bin/bash
# This file must be used with 'source .shell-env.sh' *from bash or zsh*
# you cannot run it directly

if [ -n "${SHELL_ENV:-}" ] ; then
    echo ''
    echo "Another $(_SHELL_ENV_style 'bold-underline-magenta')shell environment$(_SHELL_ENV_style) is active!"
    echo ''
    echo "    Name: ${SHELL_ENV}"
    echo "    Path: ${SHELL_ENV_ROOT}"
    echo ''
    echo "Run '$(_SHELL_ENV_style 'bold-yellow')deactivate$(_SHELL_ENV_style)' to leave it, before activating this environment."
    echo ''
    return
fi

SHELL_ENV_COLORS=${SHELL_ENV_COLORS:-0}
export SHELL_ENV_COLORS

_SHELL_ENV_style () {
    local style ncolors bold underline standout normal black red green yellow blue magenta cyan white

    if [ -n "${SHELL_ENV_COLORS:-}" ] && [ ! "${SHELL_ENV_COLORS}" = '0' ] ; then

        # see if bash supports colors...
        ncolors=256            # $(tput colors)

        if [ -n "${ncolors:-}" ] && [ $ncolors -ge 8 ] ; then
            bold='[1m'         # "$(tput bold)"
            underline='[4m'    # "$(tput smul)"
            standout='[7m'     # "$(tput smso)"
            normal='(B[m'      # "$(tput sgr0)"
            black='[30m'       # "$(tput setaf 0)"
            red='[31m'         # "$(tput setaf 1)"
            green='[32m'       # "$(tput setaf 2)"
            yellow='[33m'      # "$(tput setaf 3)"
            blue='[34m'        # "$(tput setaf 4)"
            magenta='[35m'     # "$(tput setaf 5)"
            cyan='[36m'        # "$(tput setaf 6)"
            white='[37m'       # "$(tput setaf 7)"
            local IFS=$'-'
            for style in ${1:-normal} ; do
                echo -n ${!style}
            done
        fi
    fi
}

_SHELL_ENV_rehash () {
    # This should detect bash, which has a hash command that
    # must be called to get it to forget past commands. Without
    # forgetting past commands $PATH changes may not be respected.
    if [ -n "${BASH_VERSION:-}" ] || [ -n "${BASH:-}" ] ; then
        hash -r
    fi
}

_SHELL_ENV_hook () {
    if [ -n "${1:-}" ] && [ -n "${2:-}" ] && [ -d "${2}/.shell-env/hook-${1}.d" ] ; then

        local hook root oldpath filepath filename
        hook="$1"
        root="$2"
        oldpath="$PATH"

        echo ''
        echo "Processing $(_SHELL_ENV_style 'bold-green')${hook}$(_SHELL_ENV_style) shell-environment hooks"
        echo ''

        local oldifs="${IFS}" IFS=$'\t\n'
        for filepath in "${root}/.shell-env/hook-${hook}.d/"*.{sh,bash} ; do
            IFS="${oldifs}"
            if [ ! -e "${filepath}" ] ; then
                continue
            fi
            filename=$( basename "$filepath" )
            echo "- shell-hook '$(_SHELL_ENV_style 'bold-yellow')${filename}$(_SHELL_ENV_style)'"
            if ! source "$filepath" ; then
                echo 'Failed to load shell-hook!' >&2
            fi
            oldifs="${IFS}"
        done
        IFS="${oldifs}"

        if [ ! "$PATH" = "$oldpath" ] ; then
            _SHELL_ENV_rehash
        fi
    fi
}

deactivate () {

    local root
    root="$SHELL_ENV_ROOT"

    if [ ! "$1" = 'nondestructive' ] ; then
        _SHELL_ENV_hook 'pre-deactivate' "$root"
    fi

    # reset old environment variables
    #if [ -n "${_OLD_SHELL_ENV_PATH:-}" ] ; then
    #    PATH="${_OLD_SHELL_ENV_PATH}"
    #    export PATH
    #    unset _OLD_SHELL_ENV_PATH
    #    _SHELL_ENV_rehash
    #fi

    if [ -n "${_OLD_SHELL_ENV_PS1:-}" ] ; then
        PS1="${_OLD_SHELL_ENV_PS1}"
        export PS1
        unset _OLD_SHELL_ENV_PS1
    fi

    if [ -n "${SHELL_ENV:-}" ] ; then
        unset SHELL_ENV
    fi

    if [ -n "${SHELL_ENV_ROOT:-}" ] ; then
        unset SHELL_ENV_ROOT
    fi

    if [ -n "${SHELL_ENV_COLORS:-}" ] ; then
        unset SHELL_ENV_COLORS
    fi

    if [ ! "$1" = 'nondestructive' ] ; then

        echo ''
        echo 'Left shell environment.'
        echo ''
        echo 'Good Bye!'
        echo ''

        _SHELL_ENV_hook 'post-deactivate' "$root"

        # Self destruct!
        unset -f deactivate
        unset -f _SHELL_ENV_hook
        unset -f _SHELL_ENV_rehash
        unset -f _SHELL_ENV_style
    fi
}

# unset irrelevant variables
deactivate 'nondestructive'

_SHELL_ENV_hook 'pre-activate' "$( pwd )"

SHELL_ENV_ROOT=$( pwd )
export SHELL_ENV_ROOT

SHELL_ENV=$( basename $SHELL_ENV_ROOT )
export SHELL_ENV

#_OLD_SHELL_ENV_PATH="$PATH"
#PATH="${SHELL_ENV_ROOT}/vendor/bin:$PATH"
#export PATH
#_SHELL_ENV_rehash

if [ -z "${SHELL_ENV_DISABLE_PROMPT:-}" ] ; then
    _OLD_SHELL_ENV_PS1="$PS1"
    if [ "x${SHELL_ENV}" != 'x' ] ; then
        PS1="$(_SHELL_ENV_style 'bold-green')(${SHELL_ENV})$(_SHELL_ENV_style) $PS1"
    elif [ "`basename \"${SHELL_ENV_ROOT}\"`" = '__' ] ; then
        # special case for Aspen magic directories
        # see http://www.zetadev.com/software/aspen/
        PS1="[`basename \`dirname \"${SHELL_ENV_ROOT}\"\``] $PS1"
    else
        PS1="(`basename \"${SHELL_ENV_ROOT}\"`)$PS1"
    fi
    export PS1
fi

_SHELL_ENV_hook 'post-activate' "$SHELL_ENV_ROOT"

echo ''
echo "$(_SHELL_ENV_style 'bold-underline-magenta')shell environment$(_SHELL_ENV_style)"
echo ''
echo "    Name: $(_SHELL_ENV_style 'bold-green')${SHELL_ENV}$(_SHELL_ENV_style)"
echo "    Path: $(_SHELL_ENV_style 'bold-green')${SHELL_ENV_ROOT}$(_SHELL_ENV_style)"
echo ''
echo "Run '$(_SHELL_ENV_style 'bold-yellow')deactivate$(_SHELL_ENV_style)' to exit the environment and return to normal shell."
echo ''
