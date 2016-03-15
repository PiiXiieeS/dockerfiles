#!/bin/bash

sed -i "s*ARCHTAG*$(cat ./conf/ARCHTAG)*g" Makefile
sed -i "s*ARCHTAG*$(cat ./conf/ARCHTAG)*g" Dockerfile
sed -i "s*ARCHTAG*$(cat ./conf/ARCHTAG)*g" ./scripts/mkimage-alpine-scratch.sh
