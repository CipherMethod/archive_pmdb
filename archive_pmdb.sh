#!/bin/sh

# Archive the Quest/One Identity Privilege Manager for Unix Events Database
# 20170606 - Jamey Hopkins

[ "$USER" != "root" ] && echo "switch to root" && exit

DS=`date +"%Y%m%d%H%M"`
echo "Archive Date: $DS"

echo "Stopping services."
service pmserviced stop
service pmlogsrvd stop
service pmloadcheck stop

echo "Give services 10 seconds to fully stop."
sleep 10

echo "Force kill remaining services."
killall pmmasterd
killall pmlogsrvd

cd /var/opt/quest/qpm4u/

echo "Start archive to /var/opt/quest/qpm4u/archive/$DS."
[ ! -d archive ] && echo "Creating archive directory." &&  mkdir archive
pmlogadm archive /var/opt/quest/qpm4u/pmevents.db $DS --dest-dir /var/opt/quest/qpm4u/archive --older-than 7
RS=$?
echo "Return string was: $RS"

# Verify new db:
/opt/quest/sbin/pmlogadm info /var/opt/quest/qpm4u/pmevents.db
RS=$?
echo "Return string was: $RS"

echo "Restarting services."
service pmserviced start
service pmlogsrvd start
service pmloadcheck start

