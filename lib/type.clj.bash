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

# --

# Usage: nap_type_validate_opts
# Validates cfg_clj_*.
function nap_type_validate_opts () {                            # {{{1
  validate "$cfg_clj_server"  "$chk_host" 'invalid clj.server'
  validate "$cfg_clj_port"    "$chk_port" 'invalid clj.port'
}                                                               # }}}1

# Usage: nap_type_bootstrap
# Bootstraps; dies on failure.
function nap_type_bootstrap () {                                # {{{1
  loadlib 'helper.nginx'

  local nginx="$nap_app_cfg/nginx.conf"

  cfg_nginx_server="$cfg_clj_server"
    cfg_nginx_port="$cfg_clj_port"
    cfg_nginx_host=localhost
     cfg_nginx_log="$nap_app_log"

  ohai 'creating nginx configuration ...'
  try 'nginx mkcfg failed' nap_helper_nginx_mkcfg "$nginx"

  # ...
}                                                               # }}}1

# ...

# --

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
