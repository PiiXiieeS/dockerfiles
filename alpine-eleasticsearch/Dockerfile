FROM maxder/PLACEHOLDER-base:edge
MAINTAINER Christian-Maxilian Steier

RUN apk --update add openjdk8-jre-base ca-certificates curl \
 && rm -f /var/cache/apk/*

ENV ELASTICSEARCH_VERSION 2.1.1

RUN mkdir -p /opt \
 && cd /tmp \
 && curl https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/$ELASTICSEARCH_VERSION/elasticsearch-$ELASTICSEARCH_VERSION.tar.gz > elasticsearch-$ELASTICSEARCH_VERSION.tar.gz \
 && tar -xzf elasticsearch-$ELASTICSEARCH_VERSION.tar.gz \
 && rm -rf elasticsearch-$ELASTICSEARCH_VERSION.tar.gz \
 && mv elasticsearch-$ELASTICSEARCH_VERSION /opt/elasticsearch

ADD conf/elasticsearch.yml /opt/elasticsearch/config/elasticsearch.yml

ADD service /etc/service
RUN chmod +x /etc/service/*/*

VOLUME ["/var/lib/elasticsearch"]

EXPOSE 9200
EXPOSE 9300

ENTRYPOINT ["/bin/s6-svscan", "-t0"]
CMD ["/etc/service"]
