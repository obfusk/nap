#!/bin/bash

# --                                                            # {{{1
#
# File        : lib/helper.nginx.bash
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2012-08-09
#
# Copyright   : Copyright (C) 2012  Felix C. Stegerman
# Licence     : GPLv2
#
# --                                                            # }}}1

if [ "$nap_helper_nginx_loaded" == yes ]; then
  return
else
  nap_helper_nginx_loaded=yes
fi

# --

# Usage: nap_helper_nginx_mkcfg <file>
# Writes config file; returns non-zero on failure.
# Uses $cfg_nginx_{server,log,host,port}, $cfg_name.
function nap_helper_nginx_mkcfg () {                            # {{{1
  local f="$1"
  sed 's!^    !!g' <<__END > "$f"
    server {
      listen      80;
      server_name $cfg_nginx_server;

      access_log  $cfg_nginx_log/$cfg_name-access.log;
      error_log   $cfg_nginx_log/$cfg_name-error.log;

      location / {
        proxy_pass http://$cfg_nginx_host:$cfg_nginx_port;
      }
    }
__END
}                                                               # }}}1

# Usage: nap_helper_nginx_info <type> <file>
# Outputs info.
function nap_helper_nginx_info () {                             # {{{1
  local t="$1" f="$2"
  sed 's!^    !!g' <<__END
    Your $t app has been bootstrapped.
    You now need to copy the nginx.conf file to the appropriate
    location:
      $ cp $f /path/to/nginx/conf/
    And restart nginx:
      $ service nginx restart
__END
}                                                               # }}}1

# --

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
