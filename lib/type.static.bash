#!/bin/bash

# --                                                            # {{{1
#
# File        : lib/type.static.bash
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2014-11-13
#
# Copyright   : Copyright (C) 2013  Felix C. Stegerman
# Licence     : GPLv3+
#
# --                                                            # }}}1

# --

nap_type_opts=( server depcmd public )

loadlib 'helper.daemon'   # for deps

# --

# Usage: nap_type_validate_opts
# Validates cfg_static_*.
function nap_type_validate_opts () {
  validate "$cfg_static_server" "$chk_host" 'invalid static.server'
  [ -n "$cfg_static_public" ] || fail 'invalid static.public'
  # don't validate $cfg_static_depcmd -- is command line (& optional)
}

# Usage: nap_type_install_deps
# Installs dependencies; dies on failure.
function nap_type_install_deps () {
  if [ -z "$cfg_static_depcmd" ]; then
    echo '(static: no dependencies to install)'
  else
    nap_helper_daemon_deps "$cfg_static_depcmd" $cfg_static_depcmd
  fi
}

# Usage: nap_type_bootstrap
# Bootstraps; dies on failure.
function nap_type_bootstrap () {                                # {{{1
  loadlib 'helper.nginx'

  nap_static_nginx_conf="$nap_app_cfg/nginx.conf"
       cfg_nginx_server="$cfg_static_server"
       cfg_nginx_public="$nap_app_app/$cfg_static_public"
          cfg_nginx_log="$nap_app_log"

  ohai '[nginx (static) mkcfg]'
  try '[nginx (static) mkcfg] failed' nap_helper_nginx_static_mkcfg \
    "$nap_static_nginx_conf"
}                                                               # }}}1

# Usage: nap_type_bootstrap_info
# Outputs info.
function nap_type_bootstrap_info () {
  ohai 'Caveats'
  nap_helper_nginx_info static "$nap_static_nginx_conf"
}

# --

# Usage: nap_type_status -[nqs]
# Outputs status.
function nap_type_status () {
  echo '(static)'
}

# Usage: nap_type_running [warn]
# Returns non-zero if not running; warns if dead when warn is passed.
function nap_type_running () {
  return 0  # pretend to be running
}

# Usage: nap_type_start
# Starts; dies on failure.
function nap_type_start () {
  echo '(static: no daemon to start)'
}

# Usage: nap_type_stop
# Stops; dies on failure.
function nap_type_stop () {
  echo '(static: no daemon to stop)'
}

# Usage: nap_type_restart
# Restarts; dies on failure.
function nap_type_restart () {
  echo '(static: no daemon to restart)'
}

# --

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
