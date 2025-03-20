FROM debian:bullseye

RUN apt update &&\
    apt install -y nginx openssl &&\
    mkdir -p /etc/nginx/ssl  /var/www/html &&\
    chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

RUN openssl req -newkey rsa:2048 -x509 -days 365 -nodes \
    -out /etc/ssl/certs/oettaqui.crt \
    -keyout /etc/ssl/private/oettaqui.key \
    -subj "/C=MA/ST=BENGURIR/L=BENGURIR/O=42/OU=1337/CN=oettaqui.42.fr"

COPY ./conf/default.conf /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]