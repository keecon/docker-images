FROM postgres:14

LABEL org.opencontainers.image.source https://github.com/keecon/docker-images

RUN apt update
RUN apt install -y postgresql-server-dev-14 make gcc wget libicu-dev

RUN wget https://osdn.net/projects/pgbigm/downloads/72448/pg_bigm-1.2-20200228.tar.gz
RUN tar zxf pg_bigm-1.2-20200228.tar.gz
RUN cd pg_bigm-1.2-20200228 && make USE_PGXS=1 && make USE_PGXS=1 install

RUN echo session_preload_libraries='pgcrypto,pg_trgm,pg_bigm,auto_explain' >> /var/lib/postgresql/data/postgresql.conf
RUN echo shared_preload_libraries='pg_stat_statements' >> /var/lib/postgresql/data/postgresql.conf
RUN echo auto_explain.log_min_duration='1s' >> /var/lib/postgresql/data/postgresql.conf

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 5432

CMD ["postgres"]

