FROM mcr.microsoft.com/azure-sql-edge:latest

LABEL org.opencontainers.image.source https://github.com/keecon/docker-images

USER root

# https://docs.microsoft.com/ko-kr/sql/tools/go-sqlcmd-utility?view=sql-server-ver16
RUN apt-get update \
	&& apt-get -y install software-properties-common \
	&& curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
	&& add-apt-repository "$(wget -qO- https://packages.microsoft.com/config/ubuntu/20.04/prod.list)" \
	&& apt-get update \
	&& apt-get -y install sqlcmd
