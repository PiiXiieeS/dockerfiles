#!/bin/bash

DOMAIN=${DOMAIN:-domain.org}

  echo "DOMAIN=$DOMAIN"
  if [ -z "$DOMAIN" ]; then
	sed -i "s*DOMAIN*0.0.0.0*g" /etc/hiawatha/hiawatha.conf
  else
	sed -i "s*DOMAIN*$DOMAIN*g" /etc/hiawatha/hiawatha.conf
  fi
  rm /firstrun
