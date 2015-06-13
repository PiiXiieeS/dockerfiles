docker-hiawatha
=============

A Dockerfile that installs Hiawatha with PHP

## Installation

```
git clone https://github.com/christiansteier/dockerfiles.git
cd dockerfiles/hiawatha-php
docker build -t hiawatha .
```

## Usage

To spawn a new instance of Hiawatha:

```
docker run --name hiawatha -e VIRTUAL_HOST=domain.org --d -t -p 80  hiawatha
```

You can visit the following URL in a browser to get started:

```
http://domain.org
```
