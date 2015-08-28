FROM maxder/debianbase
MAINTAINER Christian-Maximilian Steier

RUN echo "deb http://archive.debian.org/debian-archive/debian lenny main" >> /etc/apt/sources.list
RUN apt-get update \
 && apt-get install -y \
    debian-keyring \
    debian-archive-keyring \
    wget \
    build-essential \
    make \
    gcc \
    checkinstall \
    locales \
    zip \
    libjpeg-dev \
    libfreetype6 \
    libfreetype6-dev \
    zlib1g-dev \
    mime-support \
    lynx \
    imagemagick \
    poppler-utils \
    libmysqlclient-dev \
    python2.4 \
    python2.4-dev \
    python-pil

# Set timezone
RUN echo "Europe/Berlin" > /etc/timezone  \
 && dpkg-reconfigure -f noninteractive tzdata

ENV ZOPEVER 2.8.9.1
ENV LC_ALL C.UTF-8

# Setuptools for Python 2.4
RUN cd /tmp && mkdir setuptools
RUN cd /tmp/setuptools  && wget https://pypi.python.org/packages/2.4/s/setuptools/setuptools-0.6c11-py2.4.egg 
RUN cd /tmp/setuptools && sh setuptools-0.6c11-py2.4.egg
RUN rm -r /tmp/setuptools

RUN cd /tmp \
 && wget http://downloads.sourceforge.net/project/mysql-python/mysql-python/1.2.3/MySQL-python-1.2.3.tar.gz \
 && tar -zxf MySQL-python-1.2.3.tar.gz \
 && cd MySQL-python-1.2.3 \
 && python2.4 setup.py install \
 && rm -r /tmp/MySQL-python-1.2.3

# Zope 2.8
RUN cd /tmp \
 && wget http://old.zope.org/Products/Zope/$ZOPEVER/Zope-$ZOPEVER-final.tgz \
 && tar -xzvf Zope-$ZOPEVER-final.tgz \
 && rm *.tgz
RUN cd /tmp/Zope-$ZOPEVER-final \
 && ./configure BASECFLAGS=-U_FORTIFY_SOURCE --prefix=/opt/Zope-2.8 --with-python=python2.4 \
 && make \
 && make install

#  MySQL Database Adapter
RUN cd /opt/Zope-2.8 \
 && wget http://old.zope.org/Members/adustman/Products/ZMySQLDA/2.0.8/ZMySQLDA-2.0.8.tar.gz \
 && tar -cfvz ZMySQLDA-2.0.8.tar.gz \
 && rm *.tar.gz

# ZODB
RUN cd /tmp\
 && wget https://launchpad.net/ubuntu/+archive/primary/+files/zodb_3.5.1.orig.tar.gz \
 && cd /tmp && tar -xzf zodb_3.5.1.orig.tar.gz \
 && rm zodb_3.5.1.orig.tar.gz
RUN cd /tmp/ZODB3* /bin/python setup.py build
RUN cd /tmp/ZODB3* /bin/python setup.py install

RUN ln -s /usr/lib/`uname -i`-linux-gnu/libjpeg.so /usr/lib
RUN ln -s /usr/lib/`uname -i`-linux-gnu/libfreetype.so /usr/lib
RUN ln -s /usr/lib/`uname -i`-linux-gnu/libz.so /usr/lib

RUN useradd zope
RUN usermod -g zope zope
RUN echo "zope:zope" | chpasswd

ADD scripts/zpackdb.py /src/zpackdb.py
RUN echo "20 2 * * 7   /src/zpackdb.py" >> /etc/crontab

RUN mkdir /etc/service/zope
ADD service/zope.sh /etc/service/zope/run
RUN chmod +x /etc/service/zope/run

EXPOSE 8080
VOLUME /zope
