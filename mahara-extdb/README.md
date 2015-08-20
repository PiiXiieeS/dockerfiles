docker-mahara
=============

Mahara on Debian without database server like MariaDB.
Optimized for playing together with [maxder/mariadb](https://hub.docker.com/r/maxder/mariadb/).

## Installation

```
git clone https://github.com/christiansteier/dockerfiles.git
cd ../mahara
docker build -t mahara .
```

## Usage

To spawn a new instance of Mahara:

```
docker run -d --name mariadb -e USER=dbadmin -e PASS=PASSWORD -p 127.0.0.1:3306:3306 maxder/mariadb
docker run -d --name mahara -e MAHARA_WWWROOT=http://domain.org/mahara/ -e MAHARA_EMAIL=contact@domain.org --link mariadb:db -p 80  mahara
```

You can visit the following URL in a browser to get started:

```
http://domain.org/mahara
```
