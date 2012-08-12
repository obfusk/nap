#!/bin/bash

# --                                                            # {{{1
#
# File        : lib/type.ruby.bash
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2012-08-11
#
# Copyright   : Copyright (C) 2012  Felix C. Stegerman
# Licence     : GPLv2
#
# --                                                            # }}}1

# TODO {
#
#   * bundle install alternative ???
#
# } TODO

# --

nap_type_opts=( server port cmd )
cfg_ruby_cmd_d='unicorn -E production -p ${PORT}'

loadlib 'helper.daemon'

# --

# Usage: nap_type_validate_opts
# Validates cfg_ruby_*; sets default cfg_ruby_cmd.
function nap_type_validate_opts () {                            # {{{1
  validate "$cfg_ruby_server"   "$chk_host" 'invalid ruby.server'
  validate "$cfg_ruby_port"     "$chk_port" 'invalid ruby.port'

  # don't validate $cfg_ruby_cmd -- is command line
  : ${cfg_ruby_cmd:="$cfg_ruby_cmd_d"}
}                                                               # }}}1

# Usage: nap_type_install_deps
# Installs dependencies; dies on failure.
function nap_type_install_deps () {                             # {{{1
  nap_helper_daemon_deps 'bundle install' bundle install
}                                                               # }}}1

# Usage: nap_type_bootstrap
# Bootstraps; dies on failure.
function nap_type_bootstrap () {                                # {{{1
  nap_helper_daemon_nginx "$cfg_ruby_server" "$cfg_ruby_port"
}                                                               # }}}1

# Usage: nap_type_bootstrap_info
# Outputs info.
function nap_type_bootstrap_info () {                           # {{{1
  ohai 'Caveats'
  nap_helper_nginx_info "ruby ($cfg_ruby_cmd)" \
    "$nap_helper_daemon_nginx_conf"
}                                                               # }}}1

# --

# Usage: nap_type_status -[nqs]
# Outputs deamon status.
function nap_type_status () {                                   # {{{1
  nap_helper_daemon_status_info "${cfg_ruby_cmd%% *}" "$1"
}                                                               # }}}1

# Usage: nap_type_running [warn]
# Returns non-zero if not running; warns if dead when warn is passed.
function nap_type_running () {                                  # {{{1
  nap_helper_daemon_running "${cfg_ruby_cmd%% *}" ${1:+"$1"}
}                                                               # }}}1

# Usage: nap_type_start
# Starts daemon; dies on failure.
function nap_type_start () {                                    # {{{1
  ohai "PORT=$cfg_ruby_port"
  local cmd="${cfg_ruby_cmd//\${PORT\}/$cfg_ruby_port}"
  # don't quote $cmd -- is command line
  PORT="$cfg_ruby_port" nap_helper_daemon_start 7 nohup $cmd
}                                                               # }}}1

# Usage: nap_type_stop
# Stops daemon; dies on failure.
function nap_type_stop () {                                     # {{{1
  nap_helper_daemon_stop "$cfg_ruby_cmd"
}                                                               # }}}1

# Usage: nap_type_restart
# Restarts daemon; dies on failure.
function nap_type_restart () {                                  # {{{1
  nap_type_stop
  nap_type_start
}                                                               # }}}1

# --

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
