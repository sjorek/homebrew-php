
# reset old environment variables
if [ -n "${_SHELL_ENV_HOOK_RUBY_ENV_PATH:-}" ] ; then

    PATH="${_SHELL_ENV_HOOK_RUBY_ENV_PATH}"
    export PATH

    unset _SHELL_ENV_HOOK_RUBY_ENV_PATH

    _SHELL_ENV_rehash
fi
