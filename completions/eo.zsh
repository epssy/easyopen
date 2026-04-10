#compdef eo

_eo() {
  local curcontext="$curcontext" state
  _arguments '1:site:->sites' '2:subcommand:->subcommands'

  case $state in
    sites)
      local -a sites
      sites=(${(f)"$(eo --completions)"})
      _describe 'site' sites
      ;;
    subcommands)
      local -a subs
      subs=(${(f)"$(eo --completions "$words[2]")"})
      [[ ${#subs} -gt 0 ]] && _describe 'subcommand' subs
      ;;
  esac
}

_eo "$@"
