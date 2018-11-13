#!/bin/bash

MODE=$1
shift

if [ "$MODE" = "debug" ]; then
    ./test-debug.sh "$@"
elif [ "$MODE" = "release" ]; then
    ./test-release.sh "$@"
else
    echo "Unsupported mode: $MODE" >&2
fi
