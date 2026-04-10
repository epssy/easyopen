_eo() {
  local cur prev
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"

  # completing the account name after -a/--account
  if [[ "$prev" == "-a" || "$prev" == "--account" ]]; then
    # find the site name in the args
    local site_name="" i
    for (( i=1; i < COMP_CWORD; i++ )); do
      case "${COMP_WORDS[$i]}" in
        -a|--account) (( i++ )) ;;
        -*) ;;
        *) site_name="${COMP_WORDS[$i]}"; break ;;
      esac
    done
    if [[ -n "$site_name" ]]; then
      COMPREPLY=($(compgen -W "$(eo --completions accounts "$site_name")" -- "$cur"))
    fi
    return
  fi

  # find the site name and positional count, skipping flags
  local site_name="" positional=0 i skip=0
  for (( i=1; i < COMP_CWORD; i++ )); do
    if (( skip )); then
      skip=0
      continue
    fi
    case "${COMP_WORDS[$i]}" in
      -a|--account) skip=1 ;;
      -*) ;;
      *) (( positional++ )); [[ $positional -eq 1 ]] && site_name="${COMP_WORDS[$i]}" ;;
    esac
  done

  if [[ $positional -eq 0 ]]; then
    COMPREPLY=($(compgen -W "-a $(eo --completions)" -- "$cur"))
  elif [[ $positional -eq 1 && -n "$site_name" ]]; then
    COMPREPLY=($(compgen -W "$(eo --completions "$site_name")" -- "$cur"))
  fi
}

complete -F _eo eo
