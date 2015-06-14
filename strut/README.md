docker-strut
=============

A Dockerfile that installs Strut with Hiawatha

## Installation

```
git clone https://github.com/christiansteier/dockerfiles.git
cd dockerfiles/strut
docker build -t strut .
```

## Usage

To spawn a new instance of Strut:

```
docker run --name strut -e VIRTUAL_HOST=domain.org -d -p 80:80  strut
```

You can visit the following URL in a browser to get started:

```
http://domain.org
```
