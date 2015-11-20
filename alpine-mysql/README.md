# maxder/alpine-mysql

Multiple purpose MariaDB/MySQL based on Alpine

Image is based on the [gliderlabs/alpine](https://registry.hub.docker.com/u/gliderlabs/alpine/) base image

## Quickstart
```
git clone -b alpine https://github.com/christiansteier/dockerfiles.git
cd dockerfiles/alpine-mysql && ./do build && ./do run
````
## Docker image usage

```
docker run [docker-options] maxder/alpine-mysql:edge
```

If you build on a ARM platform like Raspberry PI
```
docker run [docker-options] maxder/rpi-alpine-mysql:edge
```

Note that MySQL root will be randomly generated (using pwgen). 
Root password will be displayed, during first run using output similar to this:
```
---
MySQL root Password: XXXXXXXXXXXXXXX
---
```

But you don't need root password really. If you connect locally, it should not 
ask you for password, so you can use following procedure:
```
docker exec -it mysql /bin/sh
# export TERM=xterm && mysql -u root mysql
```

## Examples

Typical usage:

```
docker run -it -v /host/dir/for/db:/var/lib/mysql -e MYSQL_DATABASE=db -e MYSQL_USER=user -e MYSQL_PASSWORD=blah maxder/rpi-alpine-mysql:edge
```

