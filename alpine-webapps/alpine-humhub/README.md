HumHub on AlpineLinux for external Database

# Quickstart #

```
git clone -b alpine https://github.com/christiansteier/dockerfiles.git
cd dockerfiles/alpine-webapps/alpine-humhub
make && make run
```

# Usage #

1. Run 

  `docker run -d -m 1g -p 127.0.0.1:8080:80 --name=humhub -e HUMHUB_DB=mysql_database -e HUMHUB_PASS=mysql_password -e HUMHUB_SUBDIR=name_for_url_subdir -e DBHOST=db -e DBPASS=mysql_admin_password -e DBADMIN=mysql_admin --link mysql:db maxder/alpine-humhub:edge`

2. Setup a reverse proxy to it

  ```
  location /name_for_url_subdir/ {
  	proxy_pass http://127.0.0.1:8080/name_for_url_subdir/;
  	proxy_redirect off;
  	proxy_buffering off;
  	proxy_set_header 	Host	$host;
  	proxy_set_header 	X-Real-IP	$remote_addr;
  	proxy_set_header        X-Forwarded-Server $host;
  	proxy_set_header	X-Forwarded-For	$proxy_add_x_forwarded_for;
  	add_header Strict-Transport-Security max-age=31536000;
  }
  ```

