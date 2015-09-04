FROM maxder/debianbase
MAINTAINER Christian-Maxilian Steier

# Install dependencies
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        libidn11 \
        liblua5.1-expat0 \
        libssl1.0.0 \
        lua-dbi-mysql \
        lua-dbi-postgresql \
        lua-dbi-sqlite3 \
        lua-event \
        lua-expat \
        lua-filesystem \
        lua-sec \
        lua-socket \
        lua-zlib \
        lua-zlib \
        lua5.1 \
        wget

# prosody installation
RUN curl https://prosody.im/files/prosody-debian-packages.key | apt-key add -
RUN echo "deb http://packages.prosody.im/debian trusty main" >> /etc/apt/sources.list
RUN apt-get update && apt-get install -y prosody

# Add modules
RUN cd /usr/lib/prosody/modules \
 && wget http://prosody-modules.googlecode.com/hg/mod_carbons/mod_carbons.lua \
         http://prosody-modules.googlecode.com/hg/mod_smacks/mod_smacks.lua
RUN sed -i '/modules_enabled/,/}/ s/}/\n\t\t"carbons"; "smacks"; "proxy65"; "bosh"; "groups"; "welcome"; "motd"; \n }/' /etc/prosody/prosody.cfg.lua

RUN echo include \"/etc/prosody/conf.d/*.cfg.lua\" >>/etc/prosody/prosody.cfg.lua
ADD conf.d/00prosody.cfg.lua /etc/prosody/conf.d/
ONBUILD ADD conf.d /etc/prosody/conf.d
ONBUILD ADD certs /etc/prosody/certs
ONBUILD RUN chown -R prosody:prosody /etc/prosody/certs && chmod 0700 /etc/prosody/certs && chmod 0600 /etc/prosody/certs/*

RUN cp -ax /etc/prosody/certs/localhost.key /etc/prosody/certs/ssl.key
RUN cp -ax  /etc/prosody/certs/localhost.crt  /etc/prosody/certs/ssl.cert

#ADD scripts/entrypoint.sh /etc/my_init.d/entrypoint.sh
#RUN chmod +x /etc/my_init.d/entrypoint.sh

RUN mkdir /etc/service/prosody
ADD service/prosody.sh /etc/service/prosody/run
RUN chmod +x /etc/service/prosody/run

RUN touch /var/lib/prosody/.keep && chown -R prosody /var/lib/prosody
VOLUME /var/lib/prosody

EXPOSE 5222 5269 5280 5347

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
