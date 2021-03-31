#!/bin/bash

set -e

# Run confd
confd -onetime -backend env

# Output rendered config
echo "===== unifi system.properties ====="
cat /usr/lib/unifi/data/system.properties
echo "===================================="

# source: https://github.com/ctindel/ubiquiti-docker/blob/master/unifi/start.sh via https://github.com/ctindel/ubiquiti-docker/blob/master/LICENSE
rm -f /var/run/unifi/unifi.pid

/usr/bin/jsvc \
  -nodetach \
  -debug \
  -home /usr/lib/jvm/java-8-openjdk-amd64 \
  -cp /usr/share/java/commons-daemon.jar:/usr/lib/unifi/lib/ace.jar \
  -pidfile /var/run/unifi/unifi.pid \
  -procname unifi \
  -Dunifi.datadir=/var/lib/unifi \
  -Dunifi.logdir=/var/log/unifi \
  -Dunifi.rundir=/var/run/unifi \
  -Xmx1024M \
  -Dfile.encoding=UTF-8 \
  com.ubnt.ace.Launcher start