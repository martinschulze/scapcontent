#!/bin/bash
# packages = firewalld

# Make sure there is a zone with ssh service enabled
firewall-cmd --permanent --zone=work --add-service=ssh

all_zones=$(firewall-cmd --get-zones)
eth_interfaces=$(ip link show up | cut -d ' ' -f2 | cut -d ':' -s -f1 | grep -E '^(en|eth)')

# Make sure all NICs are not bounded to any zone
for zone in $all_zones; do
    for interface in $eth_interfaces; do
        firewall-cmd --permanent --zone=$zone --remove-interface=$interface
    done
done

# Do not reload, otherwise SSG Test suite will be locked out
# firewall-cmd --reload
