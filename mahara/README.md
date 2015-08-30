Mahara with Elasticsearch on Debian for external Database

# Quickstart #

```
docker run -d --name=mariadb -p 127.0.0.1:3306:3306 maxder/mariadb
docker run -d --name=mahara -p 80:80 --link=mariadb:db -v /var/maharadata:/var/maharadata:rw maxder/mahara
```

# Usage #

1. Run 

`docker run -d -m 1g -p 127.0.0.1:9000:80 --name=mahara -e MAHARA_WWWROOT=http://example.org -e MAHARA_PASS="XXXX" -e MAHARA_SALD=XXXX" -e MAHARA_DB="mahara" -e DBHOST=db -e DBPASS=password -v /var/maharadata:/var/maharadata:rw --link mariadb:db maxder/mahara`

2. Setup a reverse proxy to it

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
		proxy_pass http://127.0.0.1:9000;
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

