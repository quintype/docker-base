#!/bin/bash

set -eo pipefail

export FLASK_APP=superset

# check for existence of /docker-entrypoint.sh & run it if it does
echo "Checking for docker-entrypoint"
if [ -f /docker-entrypoint.sh ]; then
  echo "docker-entrypoint found, running"
  chmod +x /docker-entrypoint.sh
  . docker-entrypoint.sh
fi

# set up Superset if we haven't already
if [ ! -f $SUPERSET_HOME/.setup-complete ]; then
  echo "Running first time setup for Superset"

  echo "Creating admin user ${ADMIN_USERNAME}"
  /usr/local/bin/flask fab create-admin \
    --username ${ADMIN_USERNAME} \
    --firstname ${ADMIN_USERNAME} \
    --lastname ${ADMIN_USERNAME} \
    --email ${ADMIN_USERNAME}@quintype.com \
    --password ${ADMIN_PASSWORD}

  echo "Initializing database"
  superset db upgrade

  echo "Creating default roles and permissions"
  superset init

  touch $SUPERSET_HOME/.setup-complete
else
  # always upgrade the database, running any pending migrations
  superset db upgrade
fi

echo "Starting up Superset gunicorn server"
gunicorn \
      -w ${WEBSERVER_WORKERS} \
      -k gevent \
      --timeout 300 \
      -b  0.0.0.0:${PORT} \
      --log-level info \
      --limit-request-line 8190 \
      "superset.app:create_app()"
