#Docker Alpine Mahara (x86_64)

Mahara based on Alpine

## Quickstart
```
git clone -b alpine https://github.com/christiansteier/dockerfiles.git
cd dockerfiles/alpine-mahara && ./do build
docker run -d --name=mysql -p 127.0.0.1:3306:3306 maxder/alpine-mysql:edge
./do run
````
## Docker image usage

``` shell
$ docker run -d --name mahara \
             -p 127.0.0.1:8080:80 \
             -e MAHARA_WWWROOT=http://example.org \
             -e MAHARA_PASS="XXXX" \
             -e MAHARA_DB="mahara" \
             -e DBHOST=db \
             -e DBPASS=password \
             -v /var/maharadata:/var/maharadata:rw \
             --link mariadb:mysql \
              maxder/alpine-mahara:edge
```

Setup a reverse proxy to it

```
server {
	     listen 80;
	     server_name mahara.example.org;
	     return 301 https://$host$request_uri;
}

server {
	listen 443;
	server_name mahara.example.org;
	ssl on;
        ssl_certificate /etc/ssl/private/example_com.cert;
        ssl_certificate_key /etc/ssl/private/example_com.key;
        location / {
		proxy_pass http://127.0.0.1:8080;
		proxy_redirect off;
		proxy_buffering off;
		proxy_set_header 	Host	$host;
		proxy_set_header 	X-Real-IP	$remote_addr;
		proxy_set_header        X-Forwarded-Server $host;
		proxy_set_header	X-Forwarded-For	$proxy_add_x_forwarded_for;
		add_header Strict-Transport-Security max-age=31536000;
	}
}
```
