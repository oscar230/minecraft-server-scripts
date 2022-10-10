_Useful scripts for operating a Minecraft server on UNIX, written in SH for the Bash implementation._

# Scripts
## Update server
Run using `./update-server.sh`.

Install script:
```
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
