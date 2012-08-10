#!/bin/bash

# --                                                            # {{{1
#
# File        : lib/helper.daemon.bash
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2012-08-10
#
# Copyright   : Copyright (C) 2012  Felix C. Stegerman
# Licence     : GPLv2
#
# --                                                            # }}}1

if [ "$nap_helper_daemon_loaded" == yes ]; then
  return
else
  nap_helper_daemon_loaded=yes
fi

# --

# Usage: nap_helper_daemon_deps <info> <cmd> <arg(s)>
# Installs dependencies; dies on failure.
function nap_helper_daemon_deps () {                            # {{{1
  local info="$1"; shift
  ohai "$info"
  dpush "$nap_app_app"
    try "$info failed" "$@"
  dpop
}                                                               # }}}1

# Usage: nap_helper_daemon_nginx <server> <port>
# Creates nginx config; sets $nap_helper_daemon_nginx_conf; dies on
# failure.
function nap_helper_daemon_nginx () {                           # {{{1
  local server="$1" port="$2"

  loadlib 'helper.nginx'

  nap_helper_daemon_nginx_conf="$nap_app_cfg/nginx.conf"

  cfg_nginx_server="$server"
    cfg_nginx_port="$port"
    cfg_nginx_host=localhost
     cfg_nginx_log="$nap_app_log"

  ohai '[nginx mkcfg]'
  try '[nginx mkcfg] failed' nap_helper_nginx_mkcfg \
    "$nap_helper_daemon_nginx_conf"
}                                                               # }}}1

# --

# Usage: nap_helper_daemon_start <n> <info> <cmd> <arg(s)>
# Starts daemon; waits n secs to see if process dies; dies on failure.
function nap_helper_daemon_start () {                           # {{{1
  local n="$1" info="$2" i; shift 2

  ohai "$info"
  dpush "$nap_app_app"
    "$@" >> "$nap_app_log/deamon.log" 2>&1 &
    local pid=$!
  dpop

  if [ "$n" -gt 0 ]; then
    ohai "[wait $n seconds]"
    for (( i=0 ; i < n ; ++i )); do sleep 1; echo -n .; done
  fi
  if ! kill -0 "$pid" 2>/dev/null; then
    [ "$n" -gt 0 ] && echo; die 'process died'
  fi
  [ "$n" -gt 0 ] && echo ' OK'

  try '[mkpid] failed' nap_mkpid "$nap_app_pidfile" "$pid"
}                                                               # }}}1

# Usage: nap_helper_daemon_stop <info>
# Stops deamon by killing pid; dies on failure.
function nap_helper_daemon_stop () {                            # {{{1
  local info="$1"

  pid="$( cat "$nap_app_pidfile" )"
  [ -n "$pid" ] || die '[getpid] failed'

  ohai "[kill] $info"
  try '[kill] failed' kill "$pid"
  try '[rmpid] failed' rm "$nap_app_pidfile"
}                                                               # }}}1

# --

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
