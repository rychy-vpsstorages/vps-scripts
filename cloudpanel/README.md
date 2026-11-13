# CloudPanel on a VPS: safe install notes

[CloudPanel](https://www.cloudpanel.io/) is a free web panel (nginx + PHP-FPM, MySQL/MariaDB, Let's Encrypt, cron, per-site users). These are the steps and pitfalls we hit while making it a ready-made environment.

Requirements: a **clean** Debian 12 or Ubuntu 22.04/24.04, at least 1 core / 2 GB RAM / 10 GB disk, ports 80, 443 and 8443.

## 1. Install

The installer stops if the hostname does not resolve:

```sh
hostname
grep "$(hostname)" /etc/hosts || echo "127.0.1.1 $(hostname)" | sudo tee -a /etc/hosts
```

Download the official installer and **check its sha256** against the one in the CloudPanel docs:

```sh
curl -sS https://installer.cloudpanel.io/ce/v2/install.sh -o install.sh
sha256sum install.sh        # compare with the hash in the docs
sudo DB_ENGINE=MARIADB_11.4 bash install.sh
```

`MARIADB_11.4` works on every supported release. On 2 cores / 2 GB the install took about 9 minutes.

## 2. Create the admin RIGHT AWAY

After the install the panel is at `https://SERVER-IP:8443`. **Whoever opens it first becomes admin**, including a bot scanning port 8443. Create the admin from the command line:

```sh
sudo clpctl user:add --userName=admin --email=you@example.com \
  --firstName=First --lastName=Last --password='LONG-PASSWORD' \
  --role=admin --timezone=Europe/Sofia --status=1
```

## 3. First site from the CLI

```sh
sudo clpctl site:add:php --domainName=example.com --phpVersion=8.3 \
  --vhostTemplate=Generic --siteUser=example --siteUserPassword='ANOTHER-PASSWORD'
sudo clpctl db:add --domainName=example.com --databaseName=example \
  --databaseUserName=example --databaseUserPassword='THIRD-PASSWORD'
```

Behind Cloudflare (orange cloud)? Set the SSL mode to **Full**, or you get an endless redirect.

## Security

- Don't leave 8443 open to the world: firewall it to your IP, or use `ssh -L 8443:localhost:8443 user@server` and open `https://localhost:8443`.
- Turn on two-factor authentication for the admin.
- Keep one system user per site (CloudPanel does this by default).

Full article: [CloudPanel on a VPS](https://forum.vpsstorages.com/viewtopic.php?t=141) · [на български](https://forum.vpsstorages.com/viewtopic.php?t=140)
