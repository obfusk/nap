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

nap_commands=( new )                                            # TODO

# Usage: nap_cmds <sep>
# Outputs commands separated by <sep>.
function nap_cmds () {
  local s="$1" IFS='|'; local x="${nap_commands[*]}"
  echo "${x//|/$s}"
}

# --

# Usage   : parse_opts <opt-rx> <arg(s)>
# Example : parse_opts 'foo|bar' foo=99 bar=100
#
# Sets cfg_<opt> for each opt parsed; returns 0 on success.
# Returns 1 and outputs arg on non-parseable arg.
# Returns 2 and outputs opt on not-recognized opt.
#
# TODO: array opts: cfg_$k+=( \$v ) ???

function parse_opts () {                                        # {{{1
  local ok="$1" x k v; shift
  for x in "$@"; do
    [[ "$x" =~ ^([a-z]+)=(.*)$ ]] || { echo "$x"; return 1; }
    k="${BASH_REMATCH[1]}" v="${BASH_REMATCH[2]}"
    [[ "$k" =~ ^($ok)$ ]]         || { echo "$k"; return 2; }
    eval "cfg_$k=\$v"
  done
}                                                               # }}}1

# --

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
