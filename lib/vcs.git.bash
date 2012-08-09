#!/bin/bash

# --                                                            # {{{1
#
# File        : lib/vcs.git.bash
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2012-08-09
#
# Copyright   : Copyright (C) 2012  Felix C. Stegerman
# Licence     : GPLv2
#
# --                                                            # }}}1

# Usage: nap_vcs_clone <repo> <dir> [<branch>]
# Clones repo to dir (w/ default branch); returns non-zero on failure.
function nap_vcs_clone () {                                     # {{{1
  local repo="$1" dir="$2" b="$3"
  git clone ${b:+-b "$b"} "$repo" "$dir"
}                                                               # }}}1

# Usage: nap_vcs_pull <dir> [<branch>]
# Pulls origin/branch; returns non-zero on git failure.
function nap_vcs_pull () {                                      # {{{1
  local dir="$1" b="$2" r
  dpush "$dir"
    git pull origin "${b:-master}"; r="$?"
  dpop
  return "$r"
}                                                               # }}}1

# ...

# --

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
