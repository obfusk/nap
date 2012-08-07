#!/bin/bash

# --                                                            # {{{1
#
# File        : lib/nap.bash
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2012-08-07
#
# Copyright   : Copyright (C) 2012  Felix C. Stegerman
# Licence     : GPLv2
#
# --                                                            # }}}1

    cfg_type=
    cfg_repo=

     cfg_vcs=git
  cfg_branch=

nap_commands=( new bootstrap )                                  # TODO

# --

# Usage: nap_help
# Exits w/ 0.
function nap_help () {                                          # {{{1
  sed 's!^    !!g' <<__END
    nap version $vsn

    Usage     : $usage
    Commmands : $( nap_cmds ', ' )
__END
  exit 0
}                                                               # }}}1

# Usage: validate <str> <rx> <info>
# Matches <str> to <rx>; handles match failure w/ fail.
function validate () {
  local s="$1" rx="$2" info="$3"
  [[ "$s" =~ ^($rx)$ ]] || fail "$info"
}

# Usage: nap_mkcfg <file>
# Writes cfg_* to file.
#
# TODO: handle shell metachars !!?
function nap_mkcfg () {                                         # {{{1
  local f="$1"
  sed 's!^    !!g' <<__END > "$f"
      cfg_type="$cfg_type"
      cfg_repo="$cfg_repo"

       cfg_vcs="$cfg_vcs"
    cfg_branch="$cfg_branch"
__END
}                                                               # }}}1

# --

# Usage: join <sep> <arg(s)>
# Outputs args separated by <sep>; must not contain `|'.
function join () {
  local s="$1" IFS='|'; shift; local x="$*"; echo "${x//|/$s}"
}

# --

# Usage: nap_cmds <sep>
# Outputs nap commands separated by <sep>.
function nap_cmds () { join "$1" "${nap_commands[@]}"; }

# Usage: searchlibs_cat <cat>
# Outputs names.
function searchlibs_cat () {
  local cat="$1"
  searchlibs "$cat"'\..*' | sed -E 's!^.*/'"$cat"'\.(.*)\.bash$!\1!'
}

# --

# Usage   : parse_opts <opt-rx> <arg(s)>
# Example : parse_opts 'foo|bar' foo=99 bar=100
#
# Sets cfg_<opt> for each opt parsed; returns 0 on success.
# Returns 1 and sets $parse_opts_error to arg on non-parseable arg.
# Returns 2 and sets $parse_opts_error to opt on not-recognized opt.
#
# TODO: array opts: cfg_$k+=( \$v ) ???

function parse_opts () {                                        # {{{1
  local ok="$1" x k v; shift
  for x in "$@"; do
    [[ "$x" =~ ^([a-z]+)=(.*)$ ]] \
      || { parse_opts_error="$x"; return 1; }
    k="${BASH_REMATCH[1]}" v="${BASH_REMATCH[2]}"
    [[ "$k" =~ ^($ok)$ ]] \
      || { parse_opts_error="$k"; return 2; }
    eval "cfg_$k=\$v"
  done
}                                                               # }}}1

# Usage: parse_opts_handled <opt-rx> <arg(s)>
# Runs parse_opts; handles errors w/ fail.
function parse_opts_handled () {                                # {{{1
  local ok="$1" e; shift
  parse_opts "$ok" "$@"; e="$?"
  [ "$e" -eq 1 ] && fail "malformed option: \`$parse_opts_error'"
  [ "$e" -eq 2 ] && fail "unknown option: \`$parse_opts_error'"
}                                                               # }}}1

# --

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
