#!/bin/bash

MODE=$1
shift

if which readelf >>/dev/null; then
    echo "[!] Requirement - readelf: OK"
else
    echo "[x] Requirement - readelf: FAIL. Install 'binutils/elfutils' package."
    exit 128
fi

if [ $1 = "" ]; then
    echo "[x] Missing required argument"
    exit 127
fi

if [ -f $1 ]; then
    echo "[!] Target : OK"
else
    echo "[x] Target : FAIL ($1 does not exists.)"
    exit 126
fi

if readelf -h "$1" 2>/dev/null | grep -q 'Class:[[:space:]]*ELF*'; then
    echo "[!] Target is ELF: OK"
else
    echo "[x] Target is ELF: FAIL"
    exit 125
fi

if [ "$MODE" = "debug" ]; then
    ./test-debug.sh "$@"
elif [ "$MODE" = "release" ]; then
    ./test-release.sh "$@"
else
    echo "Unsupported mode: $MODE" >&2
fi
