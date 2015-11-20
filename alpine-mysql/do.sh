#!/usr/bin/env bash
# ------------------------------------------------------------------
# [Christian-Maximilian Steier]
# Build a small AlpineLinux Docker image based with mysql        
# ------------------------------------------------------------------

DIR="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NAMESPACE="maxder"

if [ $(uname -m) == "armv6l" ]; then
	DISTRO="rpi-alpine"
else
	DISTRO="alpine"
fi
sed -i "s*PLACEHOLDER*${DISTRO}*g" $DIR/Dockerfile

CONTAINER_NAME="mysql"
IMAGENAME="${NAMESPACE}/${DISTRO}-${CONTAINER_NAME}:edge"

build() {
  docker build --rm -t $IMAGENAME .

  [ $? != 0 ] && error "Docker image build failed !" && exit 100
}

run() {
  docker run -d --hostname $CONTAINER_NAME --name $CONTAINER_NAME -p 127.0.0.1:3306:3306 -e DBUSER="dbadmin" -e DBPASS="$RANDOM" $IMAGENAME
  [ $? != 0 ] && error "Docker image build failed !" && exit 100
}


stop() {
  docker stop $CONTAINER_NAME
}

start() {
  docker start $CONTAINER_NAME
}

remove() {
  log "Removing previous container $CONTAINER_NAME" && \
      docker rm -f $CONTAINER_NAME &> /dev/null || true
}

log() {
  echo -e "$BLUE > $1 $NORMAL"
}

error() {
  echo ""
  echo -e "$RED >>> ERROR - $1$NORMAL"
}

help() {
  echo "-----------------------------------------------------------------------"
  echo "                      Available commands                              -"
  echo "-----------------------------------------------------------------------"
  echo -e -n "$BLUE"
  echo "   > build - Build the Docker image"
  echo "   > stop - Stop $CONTAINER_NAME"
  echo "   > start - Start $CONTAINER_NAME"
  echo "   > remove - Remove $CONTAINER_NAME"
  echo "   > help - Display this help"
  echo -e -n "$NORMAL"
  echo "-----------------------------------------------------------------------"

}

# Output colors
NORMAL="\\033[0;39m"
RED="\\033[1;31m"
BLUE="\\033[1;34m"

$*
