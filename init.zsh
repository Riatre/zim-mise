(( ${+commands[mise]} )) && () {
  local command="${commands[mise]}"

  # generating activation file
  local activatefile="$1/mise-activate.zsh"
  if [[ ! -e "$activatefile" || "$activatefile" -ot "$command" ]]; then
    "$command" activate zsh >| "$activatefile"
    zcompile -UR "$activatefile"
  fi

  if (( $+functions[_mise_hook] )); then
    function _self_destruct_mise_hook {
        _mise_hook
        # remove self from precmd
        precmd_functions=(${(@)precmd_functions:#_self_destruct_mise_hook})
        builtin unfunction _self_destruct_mise_hook
    }
    precmd_functions=( _self_destruct_mise_hook ${(@)precmd_functions:#_mise_hook} )
  fi

  source "$activatefile"

  # generating completions
  local compfile="$1/functions/_mise"
  if [[ ! -e "$compfile" || "$compfile" -ot "$command" ]]; then
    "$command" complete --shell zsh >| "$compfile"
  fi
} ${0:h}
