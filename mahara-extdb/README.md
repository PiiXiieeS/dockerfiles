docker-mahara
=============

Mahara on Debian without database server like MariaDB.
Optimized for playing together with 'maxder/mariadb'

## Installation

```
git clone https://github.com/christiansteier/docker-mahara.git
cd docker-mahara
docker build -t mahara .
```

## Usage

To spawn a new instance of Mahara:

```
docker run --name maharax -e MAHARA_WWWROOT=http://domain.org/mahara/ -e MAHARA_EMAIL=contact@domain.org -d -t -p 80  mahara
```

You can visit the following URL in a browser to get started:

```
http://domain.org/mahara
```
