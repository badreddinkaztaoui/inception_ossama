FROM debian:bullseye

WORKDIR /var/www/html

RUN apt-get update && \
    apt-get install -y php-fpm php7.4-mysqli wget mariadb-client

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

RUN wp core download --allow-root

RUN mkdir -p /run/php

RUN sed -i 's/listen = \/run\/php\/php7.4-fpm.sock/listen = 9000/g' /etc/php/7.4/fpm/pool.d/www.conf

COPY tools/wp_script.sh .
RUN chmod +x wp_script.sh

EXPOSE 9000

CMD ["bash", "./wp_script.sh"]
