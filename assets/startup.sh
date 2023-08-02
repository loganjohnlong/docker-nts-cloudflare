#!/bin/sh

CHRONY_CONF_FILE="/etc/chrony/chrony.conf"

# Set permissions on chrony run directory
if [ -d /run/chrony ]; then
    chown -R chrony:chrony /run/chrony
    chmod o-rx /run/chrony
    rm -f /var/run/chrony/chronyd.pid
fi

# Set permissions on chrony variable state directory
if [ -d /var/lib/chrony ]; then
    chown -R chrony:chrony /var/lib/chrony
fi

# Populate chrony config file.
{
    echo "# https://github.com/loganjohnlong/docker-nts-cloudflare"
    echo
    echo "# chrony.conf file generated by startup script"
    echo "# located at /opt/startup.sh"
    echo
    echo "server time.cloudflare.com iburst nts"
    echo
    echo "driftfile /var/lib/chrony/chrony.drift"
    echo "makestep 0.1 3"
    if [ "${NOCLIENTLOG}" = true ]; then
        echo "noclientlog"
    fi
    echo
    echo "allow all"
    echo "ntsdumpdir /var/lib/chrony"
} > ${CHRONY_CONF_FILE}

# startup chronyd in the foreground
exec /usr/sbin/chronyd -u chrony -d -x -L 0
