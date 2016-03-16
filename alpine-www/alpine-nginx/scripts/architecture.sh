#!/bin/bash

if [ $(uname -m) == "armv6l" ]; then echo "armhf" > ./conf/ARCHTAG ; else echo $(uname -m) > ./conf/ARCHTAG ; fi
./scripts/placeholder.sh

exit 0
