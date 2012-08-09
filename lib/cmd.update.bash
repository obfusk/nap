#!/bin/bash

# --                                                            # {{{1
#
# File        : lib/cmd.update.bash
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2012-08-09
#
# Copyright   : Copyright (C) 2012  Felix C. Stegerman
# Licence     : GPLv2
#
# --                                                            # }}}1

nap_cmd_usage='nap update <name>'

loadlib 'cmd._defaults'

# --

# Usage: nap_cmd_run <arg(s)>
# Runs nap_cmd_run_prepare_d; loads libs, cfg; updates app.
function nap_cmd_run () {                                       # {{{1
  nap_cmd_run_prepare_d 1 1 "$@"

  ohai "updating \`$cfg_name' ..."

  ohai 'loading configuration ...'
  source "$nap_app_cfgfile" || die 'loadcfg failed'
  loadlib "type.$cfg_type"

  nap_type_stop
  ohai 'updating repository ...'
  try 'pull failed' nap_vcs_pull "$nap_app_app" $cfg_branch
  nap_type_install_deps
  nap_type_start
  ohai 'done.'
}                                                               # }}}1

# Usage: nap_cmd_help
# Outputs help.
function nap_cmd_help () { nap_cmd_help_d; }

# --

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
