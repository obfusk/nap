#!/bin/bash

# --                                                            # {{{1
#
# File        : lib/type.uni.bash
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2012-08-09
#
# Copyright   : Copyright (C) 2012  Felix C. Stegerman
# Licence     : GPLv2
#
# --                                                            # }}}1

     nap_type_opts=( server port )
nap_type_uni_nginx=

# --

# Usage: nap_type_validate_opts
# Validates cfg_uni_*.
function nap_type_validate_opts () {                            # {{{1
  validate "$cfg_uni_server"  "$chk_host" 'invalid uni.server'
  validate "$cfg_uni_port"    "$chk_port" 'invalid uni.port'
}                                                               # }}}1

# Usage: nap_type_install_deps
# Installs dependencies; dies on failure.
function nap_type_install_deps () {                             # {{{1
  ohai 'installing dependencies using bundler ...'
  dpush "$nap_app_app"
    try 'bundle failed' bundle install
  dpop
}                                                               # }}}1

# Usage: nap_type_bootstrap
# Bootstraps; dies on failure.
function nap_type_bootstrap () {                                # {{{1
  loadlib 'helper.nginx'

  nap_type_uni_nginx="$nap_app_cfg/nginx.conf"

    cfg_nginx_server="$cfg_uni_server"
      cfg_nginx_port="$cfg_uni_port"
      cfg_nginx_host=localhost
       cfg_nginx_log="$nap_app_log"

  ohai 'creating nginx configuration ...'
  try 'nginx mkcfg failed' nap_helper_nginx_mkcfg \
    "$nap_type_uni_nginx"

  # ...
}                                                               # }}}1

# Usage: nap_type_bootstrap_info
# Outputs info.
function nap_type_bootstrap_info () {                           # {{{1
  ohai 'caveats'
  nap_helper_nginx_info unicorn "$nap_type_uni_nginx"
}                                                               # }}}1

# --

# Usage: nap_type_start
# ...
function nap_type_start () {                                    # {{{1
  ohai 'running app using unicorn ...'
  dpush "$nap_app_app"
    nohup unicorn -E production -p "$cfg_uni_port" \
      2>&1 >> "$nap_app_log/unicorn.log" &
    local pid=$!
  dpop
  try 'mkpid failed' nap_mkpid "$nap_app_pidfile" "$pid"
}                                                               # }}}1

# Usage: nap_type_stop
# ...
function nap_type_stop () {                                     # {{{1
  pid="$( cat "$nap_app_pidfile" )"
  [ -n "$pid" ] || die 'getpid failed'

  ohai 'killing unicorn process ...'
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
