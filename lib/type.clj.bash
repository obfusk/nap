#!/bin/bash

# --                                                            # {{{1
#
# File        : lib/type.clj.bash
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2012-08-09
#
# Copyright   : Copyright (C) 2012  Felix C. Stegerman
# Licence     : GPLv2
#
# --                                                            # }}}1

     nap_type_opts=( server port )
nap_type_clj_nginx=

# --

# Usage: nap_type_validate_opts
# Validates cfg_clj_*.
function nap_type_validate_opts () {                            # {{{1
  validate "$cfg_clj_server"  "$chk_host" 'invalid clj.server'
  validate "$cfg_clj_port"    "$chk_port" 'invalid clj.port'
}                                                               # }}}1

# Usage: nap_type_install_deps
# Installs dependencies; dies on failure.
function nap_type_install_deps () {                             # {{{1
  ohai 'installing dependencies using lein ...'
  dpush "$nap_app_app"
    try 'lein failed' lein deps
  dpop
}                                                               # }}}1

# Usage: nap_type_bootstrap
# Bootstraps; dies on failure.
function nap_type_bootstrap () {                                # {{{1
  loadlib 'helper.nginx'

  nap_type_clj_nginx="$nap_app_cfg/nginx.conf"

    cfg_nginx_server="$cfg_clj_server"
      cfg_nginx_port="$cfg_clj_port"
      cfg_nginx_host=localhost
       cfg_nginx_log="$nap_app_log"

  ohai 'creating nginx configuration ...'
  try 'nginx mkcfg failed' nap_helper_nginx_mkcfg \
    "$nap_type_clj_nginx"

  # ...
}                                                               # }}}1

# Usage: nap_type_bootstrap_info
# Outputs info.
function nap_type_bootstrap_info () {                           # {{{1
  ohai 'caveats'
  nap_helper_nginx_info clojure "$nap_type_clj_nginx"
}                                                               # }}}1

# --

# Usage: nap_type_start
# ...
function nap_type_start () {                                    # {{{1
  ohai 'running app using lein ...'
  dpush "$nap_app_app"
    PORT="$cfg_clj_port" nohup lein run :prod \
      2>&1 >> "$nap_app_log/lein.log" &
    local pid=$!
  dpop
  try 'mkpid failed' nap_mkpid "$nap_app_pidfile" "$pid"
  sleep 7; kill -0 "$pid" 2>/dev/null || die 'process died'
}                                                               # }}}1

# Usage: nap_type_stop
# ...
function nap_type_stop () {                                     # {{{1
  pid="$( cat "$nap_app_pidfile" )"
  [ -n "$pid" ] || die 'getpid failed'

  # TODO: lein zombies !!?

  ohai 'killing lein process ...'
  try 'kill failed' kill "$pid"
  try 'rmpid failed' rm "$nap_app_pidfile"
}                                                               # }}}1

# Usage: nap_type_restart
# ...
function nap_type_restart () {                                  # {{{1
  nap_type_stop
  nap_type_start
}                                                               # }}}1

# --

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
