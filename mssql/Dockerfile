FROM mcr.microsoft.com/mssql/server:2019-CU26-ubuntu-20.04

WORKDIR /usr/local/mssql

COPY ./bin ./bin
COPY ./init.d ./init.d

USER root

RUN chmod +x ./bin/entrypoint.sh
RUN chmod +x ./bin/configure-db.sh

USER mssql

ENTRYPOINT ["./bin/entrypoint.sh"]
