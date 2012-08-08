#!/bin/bash

# --                                                            # {{{1
#
# File        : lib/cmd.bootstrap.bash
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2012-08-09
#
# Copyright   : Copyright (C) 2012  Felix C. Stegerman
# Licence     : GPLv2
#
# --                                                            # }}}1

nap_cmd_usage='nap bootstrap <name>'

# --

# Usage: nap_cmd_run_bootstrap_prepare <arg(s)>
# Parses opts.
function nap_cmd_run_bootstrap_prepare () {                     # {{{1
  local usage="$nap_cmd_usage"
  [ "$#" -eq 1 ] || die "$usage" usage
  cfg_name="$1"; shift

  validate "$cfg_name" "$chk_word" 'invalid name'

  nap_app_set
  [ -e "$nap_app" ] || die "app \`$cfg_name' does not exist"
}                                                               # }}}1

# Usage: nap_cmd_run <arg(s)>
# Runs nap_cmd_run_bootstrap_prepare; loads libs, cfg; bootstraps app.
function nap_cmd_run () {                                       # {{{1
  nap_cmd_run_bootstrap_prepare "$@"

  ohai "bootstapping \`$cfg_name' ..."

  ohai 'loading configuration ...'
  source "$nap_app_cfgfile" || die 'loadcfg failed'

  loadlib "type.$cfg_type"

  nap_type_bootstrap

  ohai 'done.'
}                                                               # }}}1

# Usage: nap_cmd_help
# Outputs help.
function nap_cmd_help () {                                      # {{{1
  sed 's!^    !!g' <<__END
    Usage: $nap_cmd_usage
__END
}                                                               # }}}1

# --

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
