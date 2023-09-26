FROM postgres:14

LABEL org.opencontainers.image.source https://github.com/keecon/docker-images

RUN apt-get update \
    && apt-get install -y curl make gcc postgresql-server-dev-14 libicu-dev \
    && cd /tmp \
    && curl -L -O https://github.com/pgbigm/pg_bigm/releases/download/v1.2-20200228/pg_bigm-1.2-20200228.tar.gz \
    && tar zxvf pg_bigm-1.2-20200228.tar.gz \
    && cd pg_bigm-1.2-20200228 \
    && make USE_PGXS=1 \
    && make USE_PGXS=1 install \
    && rm -rf /tmp/pg_bigm-1.2-20200228 \
    && apt-get purge -y curl make gcc postgresql-server-dev-14 libicu-dev \
    && apt-get clean \
		&& apt-get autoremove --yes \
		&& rm -rf /var/lib/{apt,dpkg,cache,log}/

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 5432

CMD ["postgres"]

