docker-moodle
=============

A Dockerfile that installs Moodle, Apache, PHP, MariaDB and SSH

## Usage

Go to folder with the dockerfile and build container:

```                                                                                                                                                                                           
docker build -t moodle .                                                                                                                        
```

To spawn a new instance of Moodle:

```
docker run --name moodle -e VIRTUAL_HOST=domain.org -d -t -p 80 moodle
```

You can visit the following URL in a browser to get started:

```
http://domain.org/moodle
```
