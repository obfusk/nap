#!/bin/bash

# --                                                            # {{{1
#
# File        : lib/helper.daemon.bash
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2012-08-11
#
# Copyright   : Copyright (C) 2012  Felix C. Stegerman
# Licence     : GPLv2
#
# --                                                            # }}}1

# TODO {
#
#   * deal w/ old pidfile lingering after reboot !!!
#     --> init script should clean them all !?
#
# } TODO

# --

if [ "$nap_helper_daemon_loaded" == yes ]; then
  return
else
  nap_helper_daemon_loaded=yes
fi

# --

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

# Usage: nap_helper_daemon_getpid
# Outputs pid from pidfile (if any).
function nap_helper_daemon_getpid () {                          # {{{1
  [ -f "$nap_app_pidfile" ] && cat "$nap_app_pidfile"
}                                                               # }}}1

# Usage: nap_helper_daemon_chk <pid> [<name>]
# Checks if pid is alive; warns if name not equal to command; returns
# non-zero if not alive.
function nap_helper_daemon_chk () {                             # {{{1
  local pid="$1" name="$2"
  local cmd="$( ps -p "$pid" -o comm= )"

  [ -z "$cmd" ] && return 1

  if [ -n "$name" -a "$name" != "$cmd" ]; then
    opoo "process with PID $pid has command \`$cmd';"
    opoo "was expecting \`$name'"
  fi
}                                                               # }}}1

# Usage: nap_helper_daemon_chk_wait <n> <pid>
# Waits n secs to see if process dies; dies on failure.
function nap_helper_daemon_chk_wait () {                        # {{{1
  local n="$1" pid="$2" i

  if [ "$n" -gt 0 ]; then
    ohai "[wait $n seconds]"
    for (( i=0 ; i < n ; ++i )); do sleep 1; echo -n .; done
  fi
  if ! nap_helper_daemon_chk "$pid"; then
    [ "$n" -gt 0 ] && echo; die 'process died'
  fi
  [ "$n" -gt 0 ] && echo ' OK'
}                                                               # }}}1

# --

# Usage: nap_helper_daemon_deps <info> <cmd> <arg(s)>
# Installs dependencies; dies on failure.
function nap_helper_daemon_deps () {                            # {{{1
  local info="$1"; shift

  ohai "$( join ' ' "$@" )"
  dpush "$nap_app_app"
    try "$info failed" "$@"
  dpop
}                                                               # }}}1

# Usage: nap_helper_daemon_status [<name>]
# Uses pidfile and nap_helper_daemon_chk to see if process is running;
# outputs "stopped" if stopped, "<pid>" when running.
function nap_helper_daemon_status () {                          # {{{1
  local name="$1"
  local pid="$( nap_helper_daemon_getpid )"

  if [ -n "$pid" ] && nap_helper_daemon_chk "$pid" ${name:+"$name"}
  then
    echo "$pid"
  else
    echo stopped
  fi
}                                                               # }}}1

# Usage: nap_helper_daemon_start <n> [nohup] <cmd> <arg(s)>
# Starts daemon (if not running); runs nap_helper_daemon_chk_wait;
# dies on failure.
function nap_helper_daemon_start () {                           # {{{1
  local n="$1" nohup="$2"; shift
  if [ "$nohup" == nohup ]; then shift; else nohup= ; fi

  local info="$( join ' ' "$@" )"
  local name="${info%% *}"
  local status="$( nap_helper_daemon_status "$name" )"

  if [[ "$status" != stopped ]]; then
    opoo "[is running] $name"
  else
    ohai "$info"
    dpush "$nap_app_app"
      $nohup "$@"  >> "$nap_app_log/deamon.log" \
                  2>> "$nap_app_log/deamon-error.log" &
      local pid=$!
    dpop

    nap_helper_daemon_chk_wait "$pid"
    try '[mkpid] failed' nap_mkpid "$nap_app_pidfile" "$pid"
  fi
}                                                               # }}}1

# Usage: nap_helper_daemon_stop <info>
# Stops deamon (if running) by killing pid; dies on failure.
function nap_helper_daemon_stop () {                            # {{{1
  local info="$1"
  local name="${info%% *}"
  local status="$( nap_helper_daemon_status "$name" )"

  if [[ "$status" == stopped ]]; then
    opoo "[not running] $name"
  else
    ohai "[kill] $name"
    try '[kill] failed' kill "$status"    # $status is pid if running
    try '[rmpid] failed' rm "$nap_app_pidfile"
  fi
}                                                               # }}}1

# --

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
