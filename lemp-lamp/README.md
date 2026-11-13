# LEMP or LAMP on Debian / Ubuntu

**LAMP** = Linux + Apache + MariaDB + PHP. **LEMP** = the same with nginx. Quick rule:

| Situation | Pick |
|---|---|
| New project, small server (1–2 GB RAM) or traffic expected | LEMP |
| Moving a site from shared hosting with a long `.htaccess` | LAMP |
| Reverse proxy in front of Node.js / Python | LEMP |
| WordPress with page caching | either |

## LEMP

```sh
sudo apt update
sudo apt install nginx php-fpm php-mysql mariadb-server
sudo mysql_secure_installation
```

nginx ignores `.htaccess`. "Pretty URLs" for most PHP apps:

```nginx
location / {
    try_files $uri $uri/ /index.php?$args;
}
```

## LAMP

```sh
sudo apt update
sudo apt install apache2 libapache2-mod-php php-mysql mariadb-server
sudo a2enmod rewrite
sudo mysql_secure_installation
```

Don't install both web servers on one machine: both want port 80.

## How much RAM do the web server and PHP use?

```sh
ps -C apache2,nginx,php-fpm8.3 -o rss= | awk '{s+=$1} END {print s/1024 " MB"}'
```

(replace `php-fpm8.3` with your version; with mod_php, PHP lives inside apache2)

Full article: [LEMP or LAMP](https://forum.vpsstorages.com/viewtopic.php?t=143) · [на български](https://forum.vpsstorages.com/viewtopic.php?t=142)
