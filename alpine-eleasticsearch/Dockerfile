FROM maxder/alpine-base:edge
MAINTAINER Christian-Maxilian Steier

RUN apk --update add openjdk7-jre ca-certificates curl \
 && rm -f /var/cache/apk/*

ENV ELASTICSEARCH_VERSION 2.2.0

RUN mkdir -p /opt \
 && cd /tmp \
 && curl https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/$ELASTICSEARCH_VERSION/elasticsearch-$ELASTICSEARCH_VERSION.tar.gz > elasticsearch-$ELASTICSEARCH_VERSION.tar.gz \
 && tar -xzf elasticsearch-$ELASTICSEARCH_VERSION.tar.gz \
 && rm -rf elasticsearch-$ELASTICSEARCH_VERSION.tar.gz \
 && mv elasticsearch-$ELASTICSEARCH_VERSION /opt/elasticsearch \
 && adduser -h /opt/elasticsearch -S elasticsearch \
 && chown -R elasticsearch /opt/elasticsearch \
 && mkdir -p /var/log/elasticsearch \
 && chown elasticsearch /var/log/elasticsearch \
 && chmod 0755 /var/log/elasticsearch \
 && mkdir -p /var/lib/elasticsearch \
 && chown elasticsearch /var/lib/elasticsearch \
 && chmod 0755 /var/lib/elasticsearch \
 && sed -i "s*/opt/elasticsearch:/bin/false*/opt/elasticsearch:/bin/ash*g" /etc/passwd
ADD conf/elasticsearch.yml /opt/elasticsearch/config/elasticsearch.yml

ADD service /etc/service
RUN chmod +x /etc/service/*/*

VOLUME ["/var/lib/elasticsearch"]

EXPOSE 9200
EXPOSE 9300

ENTRYPOINT ["/bin/s6-svscan", "-t0"]
CMD ["/etc/service"]
