#!/usr/bin/env bash

#echo "[!] Target : $1"
echo "[!] Group: DEBUG"
FAIL_COUNT=0

# stack-protector add function call to '__stack_chk_fail'. Test if this name exist.
if readelf -s "$1" 2>/dev/null | grep -q '__stack_chk_fail'; then
    echo "[+] Stack Canary: Yes"
else
    FAIL_COUNT=$((FAIL_COUNT + 1))
    echo '[-] Stack Canary: No'
fi

if readelf -W -l "$1" 2>/dev/null | grep -q 'GNU_STACK'; then
    if readelf -W -l "$1" 2>/dev/null | grep 'GNU_STACK' | grep -q 'RWE'; then
        echo "[-] NX Supported: No"
        FAIL_COUNT=$((FAIL_COUNT + 1))
    else
        echo "[+] NX Supported: Yes"
    fi
else
    echo "[-] NX Supported: No"
    FAIL_COUNT=$((FAIL_COUNT + 1))
fi

  # check for PIE support
if readelf -h "$1" 2>/dev/null | grep -q 'Type:[[:space:]]*EXEC'; then
    echo '[-] PIE Enabled: No'
    FAIL_COUNT=$((FAIL_COUNT + 1))
elif readelf -h "$1" 2>/dev/null | grep -q 'Type:[[:space:]]*DYN'; then
    if readelf -d "$1" 2>/dev/null | grep -q 'DEBUG'; then
        echo "[+] PIE Enabled: Yes"
    else
        echo "[+] PIE Enabled: Yes"
    fi
fi

exit $FAIL_COUNT

