#!/bin/bash

# --                                                            # {{{1
#
# File        : lib/cmd.new.bash
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2012-08-07
#
# Copyright   : Copyright (C) 2012  Felix C. Stegerman
# Licence     : GPLv2
#
# --                                                            # }}}1

# Usage: nap_cmd_run <arg(s)>
function nap_cmd_run () {
  echo "--> $nap_cmd [$*] <--"
}

# Usage: nap_cmd_help
function nap_cmd_help () {
  echo ...
}

# --

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
