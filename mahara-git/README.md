docker-mahara
=============

A Dockerfile that installs Mahara from GIT, Apache, PHP, MariaDB and SSH

## Installation

```
git clone https://github.com/christiansteier/docker-mahara.git
cd docker-mahara
docker build -t mahara .
```

## Usage

To spawn a new instance of Mahara:

```
docker run --name mahara -e VIRTUAL_HOST=domain.org -e MAHARA_WWWROOT=http://domain.org/mahara/ -e MAHARA_EMAIL=contact@domain.org -d -t -p 80  mahara
```

You can visit the following URL in a browser to get started:

```
http://domain.org/mahara
```
