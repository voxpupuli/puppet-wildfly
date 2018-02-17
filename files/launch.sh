#!/bin/bash

if [ "x$WILDFLY_HOME" = "x" ]; then
    WILDFLY_HOME="/opt/wildfly"
fi

if [[ "$1" == "domain" ]]; then
    exec $WILDFLY_HOME/bin/domain.sh -c $2
else
    exec $WILDFLY_HOME/bin/standalone.sh -c $2
fi
