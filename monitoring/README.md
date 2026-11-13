# Disk and RAM alerts for a VPS (ntfy)

Small POSIX `sh` script that sends a push notification to your phone when a filesystem is almost full or available RAM is low. No agent, no account: notifications go through [ntfy](https://ntfy.sh).

## Setup

1. Install the ntfy app (Android / iOS) and subscribe to a topic with a **long random name**. Anyone who knows the name can read the alerts, so never send passwords.
2. Install the script:
   ```sh
   sudo curl -fsSL https://raw.githubusercontent.com/rychy-vpsstorages/vps-scripts/main/monitoring/check-server.sh -o /usr/local/bin/check-server.sh
   sudo chmod +x /usr/local/bin/check-server.sh
   sudo nano /usr/local/bin/check-server.sh   # set TOPIC
   ```
3. Test it: set `DISK_LIMIT=1`, run `sudo /usr/local/bin/check-server.sh`, check your phone, set it back to `90`.
4. Run it every 10 minutes:
   ```sh
   echo '*/10 * * * * root /usr/local/bin/check-server.sh' | sudo tee /etc/cron.d/check-server
   ```

The script alerts every 10 minutes for as long as the problem lasts. That is on purpose: it is hard to miss.

This only covers disk and RAM. A server that is down cannot report itself, so also add an outside uptime check (UptimeRobot, Uptime Kuma on another machine, ...).

## The server already went down. Why?

```sh
last -x reboot | head                       # when it rebooted
journalctl -b -1 -p err                     # errors from the previous boot
journalctl -k | grep -i "out of memory"     # did memory run out
sudo du -xh / --max-depth=2 | sort -h | tail -15   # what fills the disk
```

If `journalctl -b -1` says there is no previous boot, logs are not kept across reboots:

```sh
sudo mkdir -p /var/log/journal && sudo systemctl restart systemd-journald
```

Full article: [Your server went down and you heard it from your clients](https://forum.vpsstorages.com/viewtopic.php?t=145) · [на български](https://forum.vpsstorages.com/viewtopic.php?t=144)
