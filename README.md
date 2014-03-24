# sampctl

* Latest Release: [![GitHub version](https://badge.fury.io/gh/DracoBlue%2Fsampctl.png)](https://github.com/DracoBlue/sampctl/releases)
* Official Site: http://dracoblue.net/

sampctl is copyright 2014 by DracoBlue http://dracoblue.net

## What is sampctl?

If you are hosting multiple samp servers on one linux machine, you want to run them in a safe environment and might want to control them with a php/bash/whatever script.

sampctl is a tool to do the following things:

* start/stop samp servers
* run samp servers with different linux users
* manage multiple samp releases for the servers
* install new releases for samp servers

## Usage with extra user and sudo

Add a new user called `samprunner` (should be `adduser samprunner` on most linux distributions).

Set `SAMP_PROCESS_OWNER` + `SAMP_PROCESS_GROUP` to `samprunner` in your `/etc/sampctl.conf`.

It's important that `scriptfiles`, `gamemodes`, `filterscripts`, `npcmodes` and `server_log.txt` (and eventually `server.cfg`) is writable by the user. That's why `chown` them to `samprunner`. 

All other files might belong to root (samp) or any other user you want.

You usually don't want to give the server process full root access.

That's why create a file called `/etc/sudoers.d/samprunner` and
put the contents:

``` bash
sampbin ALL = (ALL) NOPASSWD: /home/sampbin/www/bin/control_server
```

Make sure the file belong only to root and are chmod'ed to `0440`.

Afterwards it's possible to run sampctl without root rights and without a password:

``` console
$ sudo sampctl list-remote-releases
```

should display all available releases.

Of course you might now also control servers:

``` console
$ sudo sampctl start-server hans
```

## Structure

### `/etc/sampctl.conf`

Contains all configuration. Will be sourced by `sampctl` command line utility.

E.g.:

``` bash
SERVER_BASE_DIRECTORY=/var/sampctl/servers/
SAMP_BINARY=samp03svr
SAMP_PROCESS_OWNER=samprunner
SAMP_PROCESS_GROUP=samprunner
RELEASES_BASE_DIRECTORY=/var/sampctl/releases/
PID_DIRECTORY=/var/sampctl/run/
```
The `SAMP_PROCESS_OWNER` variable is the user, which will run the server at the end. The file `/var/sampctl/servers/NAME/server_log.txt` will belong to this user. The folder `/var/sampctl/servers/NAME/scriptfiles/` should also belong to this user and the group `SAMP_PROCESS_GROUP`, because scriptfiles should be writable.

### `/var/sampctl/run/SERVER_NAME.pid`

Contains the pid for the server, which has its config at `$SERVER_BASE_DIRECTORY/$SERVER_NAME/`.

This path is configured with `PID_DIRECTORY`.

### `/var/sampctl/servers/SERVER_NAME/`

Contains the config (scriptfiles, gamemodes, filterscripts) for the samp server.

This path is configured with `SERVER_BASE_DIRECTORY`.

### `/var/sampctl/releases/RELEASE_NAME/`

Contains the unzipped release of samp. E.g. `samp03xsvr_R2`.

This path is configured with `RELEASES_BASE_DIRECTORY`.

## Commands

### install-release `RELEASE_NAME`

Will install the release called `RELEASE_NAME` (by appending .tar.gz and downloading it from files.sa-mp.com). Finally it unzipps the release to `$RELEASES_BASE_DIRECTORY/$RELEASE_NAME/`.

### uninstall-release `RELEASE_NAME`

Will remove the `$RELEASES_BASE_DIRECTORY/$RELEASE_NAME/` folder.

Before removal of this folder, it will check `$SERVER_BASE_DIRECTORY` for any server, which is running on this release. If there is still a server using this release, the script will abort.

### switch-release `SERVER_NAME` `RELEASE_NAME`

Will switch the server at `$SERVER_BASE_DIRECTORY/$SERVER_NAME` to the release `RELEASE_NAME`.

If the server is still running, it
will be stopped, upgraded to the release and afterwards relaunched.

### list-remote-releases

Will show all available releases from sa-mp.com and if the release is installed.

### list-releases

Will show all installed releases.

### list-servers

Will show all available servers.

### start-server `SERVER_NAME`

Will launch the server located at `$SERVER_BASE_DIRECTORY/$SERVER_NAME` with the user `SAMP_PROCESS_OWNER` (defined at `/etc/sampctl.conf`).

### stop-server `SERVER_NAME`

Will stop the server located at `$SERVER_BASE_DIRECTORY/$SERVER_NAME`.

### restart-server `SERVER_NAME`

Will run `stop` and `start` for this `SERVER_NAME`.

### server-status `SERVER_NAME`

Show the status of server `SERVER_NAME`.

### list-servers

Will list all servers + running release + port.

### create-server `SERVER_NAME` `RELEASE_NAME` `PORT` `RCON_PASSWORD`

Will create a new server and symlink the executables of `RELEASE_NAME`'s `samp03svr`+`announce`+`samp-npc` into the directory.

The newly created server will live at `$SERVER_BASE_DIRECTORY/$SERVER_NAME`.

sampctl generates the `default.server.cfg` in the **create-server** commend with the contents:

    rcon_password given rcon password
    port given port

This will be merged into `server.cfg` automatically whenever the server is (re)started and when invoking the **rebuild-server-config** command manually.

### delete-server `SERVER_NAME`

Will remove the server at `$SERVER_BASE_DIRECTORY/$SERVER_NAME` from the filesystem.

### rebuild-server-config `SERVER_NAME`

Will replace (or append) all keys from `$SERVER_BASE_DIRECTORY/$SERVER_NAME/default.server.cfg` in the corresponding `server.cfg`.

The command will be automatically executed before the server is started or restarted.

sampctl generates the `default.server.cfg` in the **create-server** commend with the contents:

    rcon_password given rcon password
    port given port

## Changelog

* dev
  - added logic to write/update port+rcon_password (from `default.server.cfg` on server start/restart
  - added print for sampctl config with `--version`
  - initial release (runs on linux like ubuntu)

## License

sampctl is licensed under the terms of MIT. See `LICENSE.md` for more information.


