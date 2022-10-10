_Useful scripts for operating a Minecraft server on UNIX, written in SH for the Bash implementation._

# Scripts ✨
## Update server
Run using `./update-server.sh`.

Install dependencies and the script (_coreutil_ is for the `sha1sum` command):
```
$ sudo pacman -S curl jq coreutils
$ curl https://raw.githubusercontent.com/oscar230/minecraft-server-scripts/main/update-server.sh > update-server.sh
$ chmod +x update-server.sh
```

Setup for autorun at [09:00 every day](https://crontab.guru/#0_9_*_*_*) using [mcrcon](https://github.com/Tiiffi/mcrcon) ([AUR](https://aur.archlinux.org/packages/mcrcon)):
```
$ sudo pacman -S cronie
$ sudo systemctl enable cronie.service --now
$ (crontab -l ; echo "0 9 * * * mcrcon -p PaSsWoRd -w 10 save-all stop && ~/update-server.sh && mcrcon -p PaSsWoRd start") | crontab -
```
Remember to [enable rcon](https://github.com/Tiiffi/mcrcon#enable-rcon-on-server), if youre using a remote game server look for the [`-H` option](https://github.com/Tiiffi/mcrcon#usage). You can edit your crontab using `EDITOR=vim crontab -e`.

## Server [systemd service](https://wiki.archlinux.org/title/systemd)
Based on [the service](https://gist.github.com/dotStart/ea0455714a0942474635#file-minecraft-service) written by [dotStart](https://gist.github.com/dotStart). Remember to edit `User=minecraft` to reflect your current user... psst `whoami`. Place this service in `/etc/systemd/system/minecraft.service`, start and enable it with `sudo systemctl daemon-reload && sudo systemctl enable minecraft.service --now`.
```
[Unit]
Description=Minecraft Server
Wants=network-online.target
After=network-online.target

[Service]
User=minecraft
WorkingDirectory=/opt/minecraft

# You can customize the maximum amount of memory as well as the JVM flags here
ExecStart=/usr/bin/java -XX:+UseG1GC -Xmx2G -jar server.jar
ExecStop=/var/minecraft/mcrcon -p PaSsWoRd stop

# Restart the server when it is stopped or crashed
Restart=always
RestartSec=60

# Do not remove this!
StandardInput=null

[Install]
WantedBy=multi-user.target
```
