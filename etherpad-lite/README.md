# Etherpad Lite image for docker

This is a docker image for [Etherpad Lite](http://etherpad.org/) collaborative
text editor. The Dockerfile for this image has been inspired by the
[official Wordpress](https://registry.hub.docker.com/_/wordpress/) Dockerfile and
[johbo's etherpad-lite](https://registry.hub.docker.com/u/johbo/etherpad-lite/)
image.

This image uses an mariadb container for the backend for the pads. It is based
on debian jessie instead of the official node docker image, since the latest
stable version of etherpad-lite does not support npm 2.

## Quickstart

First you need a running mariadb container:

```bash
$ docker run -d --name=mariadb -p 127.0.0.1:3306:3306 maxder/mariadb
```

Finally you can build and start an instance of Etherpad Lite:

```bash
$ docker build --rm -t="etherpad-lite" github.com/christiansteier/dockerfiles/etherpad-lite
$ docker run -d --link=mariadb:db --name etherpad -p 9001:9001 etherpad-lite
```

This will create an etherpad database to the mysql container, if it does not
already exist. You can now access Etherpad Lite from http://localhost:9001/

## Environment variables

This image supports the following environment variables:

* `ETHERPAD_TITLE`: Title of the Etherpad Lite instance. Defaults to "Etherpad".
* `ETHERPAD_ADMIN_PASS`: If set, an admin account is enabled for Etherpad,
and the /admin/ interface is accessible via it.
* `ETHERPAD_ADMIN_USER`: If the admin password is set, this defaults to "admin".
Otherwise the user can set it to another username.

* `ETHERPAD_DB_USER`: By default Etherpad Lite will attempt to connect as root
to the mysql container. This allows to change this.
* `ETHERPAD_DB_PASSWORD`: The password for the mysql user. If the root user is
used, then the password will default to the mysql container's
`MYSQL_ROOT_PASSWORD`.
* `ETHERPAD_DB_NAME`: The mysql database to use. Defaults to *etherpad*. If the
database is not available, it will be created when the container is launched.

The generated settings.json file will be available as a volume under
*/opt/etherpad-lite/var/*.
