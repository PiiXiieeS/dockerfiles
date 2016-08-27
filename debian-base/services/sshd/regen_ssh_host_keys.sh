#!/bin/execlineb -P

if -t { s6-test ! -f /etc/s6/services/sshd/down }
if -t { s6-test ! -f /etc/ssh/ssh_host_rsa_key }
if { dpkg-reconfigure openssh-server }
