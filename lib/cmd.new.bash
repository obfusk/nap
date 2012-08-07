#!/bin/bash

# --                                                            # {{{1
#
# File        : lib/cmd.new.bash
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2012-08-07
#
# Copyright   : Copyright (C) 2012  Felix C. Stegerman
# Licence     : GPLv2
#
# --                                                            # }}}1

nap_cmd_usage='nap new <name> <type> [ <opt(s)> ]'

# --

# Usage: nap_cmd_run <arg(s)>
# ...
function nap_cmd_run () {                                       # {{{1
  local usage="$nap_cmd_usage"
  [ "$#" -ge 2 ] || die "$usage" usage
  local name="$1" type="$2"; shift 2
  local cfg_vcs=git cfg_branch
  parse_opts_handled 'vcs|branch' "$@"

  echo "--> [$nap_cmd][$name][$type] <--"
  echo "--> [$cfg_vcs][$cfg_branch] <--"

  # ...
}                                                               # }}}1

# Usage: nap_cmd_help
# Outputs help.
function nap_cmd_help () {                                      # {{{1
  sed 's!^    !!g' <<__END
    Usage: $nap_cmd_usage

    Options:
      vcs=...     default is git
      branch=...  default is default branch (usually master)

    Types : $( join ', ' $( searchlibs_cat type ) )
    VCSs  : $( join ', ' $( searchlibs_cat vcs  ) )
__END
}                                                               # }}}1

# --

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
