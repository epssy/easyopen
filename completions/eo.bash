_eo() {
  local cur prev
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"

  if [[ $COMP_CWORD -eq 1 ]]; then
    COMPREPLY=($(compgen -W "$(eo --completions)" -- "$cur"))
  elif [[ $COMP_CWORD -eq 2 ]]; then
    COMPREPLY=($(compgen -W "$(eo --completions "$prev")" -- "$cur"))
  fi
}

complete -F _eo eo
