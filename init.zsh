(( ${+commands[mise]} )) && () {
  local command="${commands[mise]}"

  # generating activation file
  local activatefile="$1/mise-activate.zsh"
  if [[ ! -e "$activatefile" || "$activatefile" -ot "$command" ]]; then
    "$command" activate --no-hook-env zsh >| "$activatefile"
    zcompile -UR "$activatefile"
  fi

  source "$activatefile"

  _mise_hook() {
    eval "$(command mise hook-env -s zsh)";
  }
  typeset -ag precmd_functions;
  if [[ -z "${precmd_functions[(r)_self_destruct_mise_hook]+1}" ]]; then
    function _self_destruct_mise_hook {
      _mise_hook
      # remove self from precmd
      precmd_functions=(${(@)precmd_functions:#_self_destruct_mise_hook})
      builtin unfunction _self_destruct_mise_hook
    }
    precmd_functions=( _self_destruct_mise_hook ${(@)precmd_functions:#_mise_hook} )
  fi
  typeset -ag chpwd_functions;
  if [[ -z "${chpwd_functions[(r)_mise_hook]+1}" ]]; then
    chpwd_functions=( _mise_hook ${chpwd_functions[@]} )
  fi

  # generating completions
  local compfile="$1/_mise"
  if [[ ! -e "$compfile" || "$compfile" -ot "$command" ]]; then
    "$command" complete --shell zsh >| "$compfile"
  fi
} ${0:h}
