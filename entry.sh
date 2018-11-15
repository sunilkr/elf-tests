#!/bin/bash

MODE=$1
shift

echo "[!] Target : $1"

if [ $1 = "" ]; then
    echo "[x] Missing required argument"
    exit 127
fi

if [ -f $1 ]; then
    echo "[!] Exists: Yes"
else
    echo "[x] Exists: No"
    exit 126
fi

if which readelf >>/dev/null; then
    echo "[!] Requirement - readelf: OK"
else
    echo "[x] Requirement - readelf: FAIL. Install 'binutils/elfutils' package."
    exit 128
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
