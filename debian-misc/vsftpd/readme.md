vsftpd
===============

Light **vsftpd** installation based on *Debian* based on work of Odiobill.

By design, it will only run the **vsftpd** executable, exposing the FTP standard port and exporting */etc* as a volume for both the *configuration* files and the *local users* database, allowing you to add any account. It is very handy when you want to provide FTP access to the content of some website from another container, importing its volumes.

You can execute it with something like:

    docker run -d --name vsftpd -e "DOCKER_HOST=$(/sbin/ip route|awk '/default/ { print $3 }')" -p 21:21 -p 10100:10100 -p 10101:10101 --volumes-from YOUR-WEB-SERVER maxder/vsftpd

To to add any user, you may want to run another (temporary) container that imports its volumes. Run it with:

    docker run -i -t --name config.vsftpd --volumes-from vsftpd maxder/vsftpd bash

Then you can use the *useradd* system command to define them and having the same accounts also on the main **vsftpd** container. For example:

    adduser USERNAME --home /var/www/html/ --ingroup www-data --shell /bin/false

