#!/bin/bash

# --                                                            # {{{1
#
# File        : lib/type.clj.bash
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2012-08-11
#
# Copyright   : Copyright (C) 2012  Felix C. Stegerman
# Licence     : GPLv2
#
# --                                                            # }}}1

# TODO {
#
#   * lein zombies !!!
#   * lein deps alternative ???
#
# } TODO

# --

nap_type_opts=( server port cmd )
cfg_clj_cmd_d='lein run :prod'

loadlib 'helper.daemon'

# --

# Usage: nap_type_validate_opts
# Validates cfg_clj_*; sets default cfg_clj_cmd.
function nap_type_validate_opts () {                            # {{{1
  validate "$cfg_clj_server"  "$chk_host" 'invalid clj.server'
  validate "$cfg_clj_port"    "$chk_port" 'invalid clj.port'

  # don't validate $cfg_clj_cmd -- is command line
  : ${cfg_clj_cmd:="$cfg_clj_cmd_d"}
}                                                               # }}}1

# Usage: nap_type_install_deps
# Installs dependencies; dies on failure.
function nap_type_install_deps () {                             # {{{1
  nap_helper_daemon_deps 'lein deps' lein deps
}                                                               # }}}1

# Usage: nap_type_bootstrap
# Bootstraps; dies on failure.
function nap_type_bootstrap () {                                # {{{1
  nap_helper_daemon_nginx "$cfg_clj_server" "$cfg_clj_port"
}                                                               # }}}1

# Usage: nap_type_bootstrap_info
# Outputs info.
function nap_type_bootstrap_info () {                           # {{{1
  ohai 'Caveats'
  nap_helper_nginx_info "clojure ($cfg_clj_cmd)" \
    "$nap_helper_daemon_nginx_conf"
}                                                               # }}}1

# --

# Usage: nap_type_start
# Starts daemon; dies on failure.
function nap_type_start () {                                    # {{{1
  ohai "PORT=$cfg_clj_port"
  # don't quote $cfg_clj_cmd -- is command line
  PORT="$cfg_clj_port" nap_helper_daemon_start 7 nohup $cfg_clj_cmd
}                                                               # }}}1

# Usage: nap_type_stop
# Stops daemon; dies on failure.
function nap_type_stop () {                                     # {{{1
  nap_helper_daemon_stop "$cfg_clj_cmd"
}                                                               # }}}1

# Usage: nap_type_restart
# Restarts daemon; dies on failure.
function nap_type_restart () {                                  # {{{1
  nap_type_stop
  nap_type_start
}                                                               # }}}1

# --

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
