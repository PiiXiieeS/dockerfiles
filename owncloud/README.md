ownCloud on Debian

# Usage #

1. Run 

`docker run -d -m 1g -p 127.0.0.1:9000:80 --name="owncloud" -v /var/owncloud/data:/var/www/owncloud/data -v /var/owncloud/config:/var/www/owncloud/config maxder/owncloud`

2. Setup a reverse proxy to it

```
server {
	     listen 80;
	     server_name owncloud.example.com;
	     return 301 https://$host$request_uri;
}

server {
	listen 443;
	server_name owncloud.example.com;
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
}```
