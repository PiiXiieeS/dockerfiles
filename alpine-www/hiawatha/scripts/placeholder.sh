#!/bin/bash

sed -i "s*ARCHTAG*$(cat ./conf/ARCHTAG)*g" Makefile
sed -i "s*ARCHTAG*$(cat ./conf/ARCHTAG)*g" Dockerfile
