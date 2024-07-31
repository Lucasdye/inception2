# add a base image (debian) for the container to run on
FROM debian:bullseye

RUN apt-get update -y && \
    apt-get install -y nginx openssl

# Creating required folders for ssl files
RUN mkdir -p /etc/nginx/ssl /var/run/nginx /var/www/html

# Generate SSL certificate
RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=lbouguet.42.fr/UID=lbouguet"

COPY ./conf/nginx.conf /etc/nginx/nginx.conf

# Set permissions 755: full permission for the owner of the file, only rx for group and others.
RUN chmod 755 /var/www/html && \
    chown -R www-data:www-data /var/www/html

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
