#!/bin/sh
# Disk and RAM alert for a Linux VPS, sent to your phone via ntfy (https://ntfy.sh).
# Run from cron, e.g.: */10 * * * * root /usr/local/bin/check-server.sh
# Guide: https://forum.vpsstorages.com/viewtopic.php?t=145

TOPIC=my-server-change-me-k7q2x9   # long random name - anyone who knows it can read the alerts
DISK_LIMIT=90                      # alert when a filesystem is at or above this %
RAM_MIN_MB=200                     # alert when available RAM drops below this

# disk: every filesystem above the limit
df -P -x tmpfs -x devtmpfs | awk -v l=$DISK_LIMIT 'NR>1 {sub("%","",$5); if ($5+0 >= l) print $6, $5"%"}' |
while read fs pct; do
  curl -s -d "$(hostname): disk $fs is $pct full" https://ntfy.sh/$TOPIC >/dev/null
done

# RAM: how many MB are really available
free_mb=$(free -m | awk '/^Mem:/ {print $7}')
if [ "$free_mb" -lt "$RAM_MIN_MB" ]; then
  curl -s -d "$(hostname): only $free_mb MB RAM available" https://ntfy.sh/$TOPIC >/dev/null
fi
