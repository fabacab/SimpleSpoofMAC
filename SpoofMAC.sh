#!/bin/sh -
. /etc/rc.common

StartService ()
{
    ConsoleMessage "Running SpoofMAC script."
    ConsoleMessage "Path is $PATH"
    if [ "$SIMPLE_SPOOF_MAC_AND_NAME" -eq 1 ]; then
        local new_name=`openssl rand -hex 3`
        networksetup -setcomputername "$new_name"
        scutil --set LocalHostName "$new_name"
        scutil --set HostName "$new_name"
    fi
    local WIFI_HW_PORT=`networksetup -listallhardwareports \
        | grep -A 2 'Wi-Fi' | grep -E '^Device' | cut -d ' ' -f 2`
    if [ x`getAirportPowerState "$WIFI_HW_PORT"` == x"Off" ]; then
        networksetup -setairportpower "$WIFI_HW_PORT" on
        sleep 2 # wait for power-on
    fi
    # Manually disassociate from networks
    /System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport -z
    sleep 2 # wait for dissociation
    ifconfig "$WIFI_HW_PORT" ether 00:`openssl rand -hex 5 | sed 's/\(..\)/\1:/g; s/.$//'`
    networksetup -detectnewhardware
    # Show me the changes.
    ifconfig "$WIFI_HW_PORT" | grep ether
}

StopService ()
{
    return 0
}

RestartService ()
{
    return 0
}

# Helper functions
getAirportPowerState ()
{
    echo `networksetup -getairportpower "$1" \
        | cut -d ':' -f 2 \
            | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'`
}

RunService "$1"
