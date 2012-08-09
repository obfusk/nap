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

loadlib 'helper.daemon'

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
  ohai 'caveats'
  nap_helper_nginx_info clojure "$nap_helper_daemon_nginx_conf"
}                                                               # }}}1

# --

# Usage: nap_type_start
# Starts daemon; dies on failure.
function nap_type_start () {                                    # {{{1
  PORT="$cfg_clj_port" nap_helper_daemon_start 7 'lein run' \
    nohup lein run :prod
}                                                               # }}}1

# Usage: nap_type_stop
# Stops daemon; dies on failure.
function nap_type_stop () {                                     # {{{1
  # TODO: lein zombies !!?
  nap_helper_daemon_stop lein
}                                                               # }}}1

# Usage: nap_type_restart
# Restarts daemon; dies on failure.
function nap_type_restart () {                                  # {{{1
  nap_type_stop
  nap_type_start
}                                                               # }}}1

# --

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
