#!/bin/bash

# --                                                            # {{{1
#
# File        : lib/nap
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2012-08-06
#
# Copyright   : Copyright (C) 2012  Felix C. Stegerman
# Licence     : GPLv2
#
# --                                                            # }}}1

nap_commands=( new boot update start stop restart foo bar baz qux )
  # TODO

function nap_cmds () {
  local s="$1" IFS='|'; local x="${nap_commands[*]}"
  echo "${x//|/$s}"
}

# --

function parse_opts () {                                        # {{{1
  local x k v
  for x in "$@"; do
    [[ "$x" =~ ^([a-z]+)=(.*)$ ]] || return 1                   # TODO
    k="${BASH_REMATCH[1]}"; v="${BASH_REMATCH[2]}"
    eval "cfg_$k=\$v"
  done
}                                                               # }}}1

# --

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
