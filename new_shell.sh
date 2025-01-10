#!/bin/bash
set -e

if [ "$( docker container inspect -f '{{.State.Running}}' ece5532_noetic )" == "false" ]; then
    echo "Container not running yet, attempting to start it..."
    ./run.sh
fi

docker exec -it ece5532_noetic /bin/bash