FROM python:3-alpine

# run-time depedencies to keep:
#RUN apk add --no-cache git #libpq libxml2 libxslt nginx

# install the application
RUN apk add --no-cache --virtual .git git \
    && git clone https://github.com/healthchecks/healthchecks.git /app \
    && apk del .git

WORKDIR /app

# install the depedencies
RUN set -x \
    && apk add --no-cache --virtual .build-requirements \
        postgresql-dev postgresql-client mariadb-dev git gcc musl-dev linux-headers libxml2-dev libxslt-dev \
    && pip install -r requirements.txt mysqlclient gunicorn \
    && apk del .build-requirements \
    && apk add --no-cache mariadb-libs libpq nginx libxml2 libxslt

# configure chaperone
RUN pip install chaperone
COPY docker/chaperone.conf /etc/chaperone.d/

# configure nginx
COPY docker/nginx.conf /etc/nginx/
COPY docker/gunicorn.py /etc/
COPY docker/gunicorn_logging.ini /etc/
# configure the django application
COPY docker/django_settings.py /app/hc/local_settings.py

EXPOSE 80

ENTRYPOINT ["/usr/local/bin/chaperone"]
