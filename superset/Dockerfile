# tag: clickhouse
FROM python:3.8-slim
LABEL maintainer="devops@quintype.com"

# Superset setup options
ENV SUPERSET_VERSION 1.5.1
ENV SUPERSET_HOME /superset

ENV DB_PACKAGES libpq-dev
ENV DB_PIP_PACKAGES psycopg2-binary sqlalchemy-redshift

RUN apt-get update \
&& apt-get install -y \
  $DB_PACKAGES \
  build-essential gcc git \
  libssl-dev libffi-dev libsasl2-dev libldap2-dev \
&& pip install --no-cache-dir \
  $DB_PIP_PACKAGES apache-superset==$SUPERSET_VERSION \
  email_validator gunicorn[gevent] pillow markupsafe==2.0.1 \
&& apt-get remove -y \
  build-essential libssl-dev libffi-dev libsasl2-dev libldap2-dev git \
&& apt-get -y autoremove && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN pip install --force-reinstall cryptography==38.0.4

RUN pip install --force-reinstall wtforms==2.3.3

RUN pip install markupsafe==2.0.1

RUN pip install clickhouse-connect

RUN apt-get update \
&& apt-get autoremove -y \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

ENV PYTHONPATH $SUPERSET_HOME:$PYTHONPATH

COPY superset_config.py $SUPERSET_HOME/superset_config.py

COPY superset-init.sh /app/superset-init.sh
RUN chmod +x /app/superset-init.sh

EXPOSE $PORT

ENTRYPOINT [ "/app/superset-init.sh" ]
