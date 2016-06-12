#!/bin/bash
set -e
 source /bd_build/buildconfig
set -x

## Often used tools.
$minimal_apt_get_install less vim-tiny psmisc
ln -s /usr/bin/vim.tiny /usr/bin/vim

