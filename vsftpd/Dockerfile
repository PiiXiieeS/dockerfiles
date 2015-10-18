FROM maxder/debianbase
MAINTAINER Christian-Maxilian Steier

ADD scripts/first_run.sh /etc/my_init.d/firstrun.sh
RUN chmod +x /etc/my_init.d/firstrun.sh
RUN touch /firstrun

RUN apt-get update \
 && apt-get -y --no-install-recommends install \
    vsftpd

RUN mv /etc/vsftpd.conf /etc/vsftpd.conf.bak \
 && touch /etc/vsftpd.conf \
 && echo "local_enable=YES\nchroot_local_user=YES\nwrite_enable=YES\nanonymous_enable=NO\nallow_writeable_chroot=YES\nftpd_banner=Welcome\nfile_open_mode=0644\nlocal_umask=022\nftp_username=www-data\nchmod_enable=YES\nchown_uploads=YES\nchown_username=www-data\nforce_dot_files=YES\n\n#Passive Mode\npasv_enable=YES\npasv_promiscuous=YES\npasv_min_port=10090\npasv_max_port=10100\npasv_address=DOCKERHOST\n\n#PEM Key\nrsa_private_key_file=/etc/ssl/private/vsftpd.pem\nrsa_cert_file=/etc/ssl/private/vsftpd.pem\n\n#SSL Configuartion\nssl_enable=YES\nallow_anon_ssl=NO\nforce_local_data_ssl=YES\nforce_local_logins_ssl=YES\n\nssl_tlsv1=YES\nssl_sslv2=NO\nssl_sslv3=NO\n\nrequire_ssl_reuse=NO\nssl_ciphers=HIGH\n" >> /etc/vsftpd.conf \
 && mkdir -p /var/run/vsftpd/empty \
 && echo "/bin/false" >> /etc/shells

VOLUME /etc

CMD ["/sbin/my_init", "vsftpd"]
