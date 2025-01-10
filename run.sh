#!/bin/bash

set -e

GREEN="\033[0;32m"
NOCOLOR="\033[0m"

cleanup () {
    xhost -local:docker
}
trap cleanup EXIT

HOST_WORKSPACE_DIR="$PWD/ros"
IMAGE_NAME="robustify101/ece5532_noetic"
CONTAINER_WORKSPACE_DIR="/home/workspace"

docker inspect "$IMAGE_NAME" > /dev/null 2>&1 || docker pull $IMAGE_NAME

XAUTH=/tmp/.docker.xauth
if [ ! -f $XAUTH ]
then
    xauth_list=$(xauth nlist :0 | sed -e 's/^..../ffff/' | tail -1)
    if [ ! -z "$xauth_list" ]
    then
        echo $xauth_list | xauth -f $XAUTH nmerge -
    else
        touch $XAUTH
    fi
    chmod a+r $XAUTH
fi

xhost +local:docker

docker start ece5532_noetic || \
(echo "Creating new container..." && \
docker run -itd \
    --env="DISPLAY=$DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --env="XAUTHORITY=$XAUTH" \
    --volume="$XAUTH:$XAUTH" \
    --volume="$HOST_WORKSPACE_DIR:$CONTAINER_WORKSPACE_DIR" \
    --runtime=nvidia \
    --name=ece5532_noetic \
    $IMAGE_NAME \
&& echo "Done!"
)