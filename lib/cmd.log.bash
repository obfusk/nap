#!/bin/bash

# --                                                            # {{{1
#
# File        : lib/cmd.log.bash
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2012-08-24
#
# Copyright   : Copyright (C) 2012  Felix C. Stegerman
# Licence     : GPLv2
#
# --                                                            # }}}1

nap_cmd_usage='nap log <name> ...'
nap_subcmds=( list files tail monitor hist )

loadlib 'cmd._defaults'

# --

# Usage: nap_cmd_run <arg(s)>
# Runs nap_cmd_run_prepare_d; loads libs, cfg; ...
function nap_cmd_run () {                                       # {{{1
  nap_cmd_run_prepare_d 2 '' "$@"

  # TODO {

  local cmd="$2"; shift 2
  [[ "$cmd" =~ ^($( join '|' "${nap_subcmds[@]}" ))$ ]] \
    || die "$nap_cmd_usage" usage

  # TODO: validate, ohai

  # ohai "[log $cmd] \`$cfg_name'"

  source "$nap_app_cfgfile" || odie '[loadcfg] failed'
  loadlib "type.$cfg_type"
  loadlib "vcs.$cfg_vcs"

  nap_logs

  case "$cmd" in
    list)     nap_log_list                      ;;
    files)    nap_log_files                     ;;
    tail)     nap_log_tail 10 "$@"              ;;
    monitor)  nap_log_monitor 10 "$1"           ;;
    hist)     nap_vcs_log "$nap_app_app" 10  ;;
  esac

  # ohai '[done]'

  # } TODO

  return 0
}                                                               # }}}1

# Usage: nap_cmd_help
# Outputs help.
function nap_cmd_help () { nap_cmd_help_d; }

# --

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
