#!/usr/bin/with-contenv sh
set -e
if [ ! -e /etc/s6/services/sshd/down && ! -e /etc/ssh/ssh_host_rsa_key ] || [ "$1" == "-f" ]; then
	echo "No SSH host key available. Generating one..."
	export LC_ALL=C
	export DEBIAN_FRONTEND=noninteractive
	dpkg-reconfigure openssh-server
fi
