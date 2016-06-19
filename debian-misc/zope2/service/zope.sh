#!/bin/sh

ZOPE_HOME="/zope"
INSTANCE_HOME="$ZOPE_HOME/instance"
ZOPEBIN="/opt/Zope-2.8/bin"
PYTHON="$ZOPEBIN/zopepy"

#CONFIG_FILE="$INSTANCE_HOME/etc/zope.conf"
export INSTANCE_HOME
export PYTHON

if [ ! -d "$INSTANCE_HOME/etc" ]; then
  $ZOPEBIN/mkzopeinstance.py -u zope:2epoz -d $INSTANCE_HOME
#  cp /src/zope.conf $INSTANCE_HOME/etc/
  chown -R zope:zope $ZOPE_HOME
fi

export PYTHON_EGG_CACHE=/tmp

exec /sbin/setuser zope $INSTANCE_HOME/bin/zopectl fg
