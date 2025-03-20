FROM debian:bullseye

RUN apt update -y && \
    apt upgrade -y && \
    apt install mariadb-server -y && \
    mkdir -p /etc/mysql/mariadb.conf.d

COPY conf/50-server.cnf	/etc/mysql/mariadb.conf.d/50-server.cnf

COPY tools/setup.sh /bin/
RUN	chmod +x /bin/setup.sh

CMD	["setup.sh"]