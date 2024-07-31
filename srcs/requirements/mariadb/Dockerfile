FROM debian:bullseye

RUN apt-get update -y && apt-get install -y mariadb-server 

RUN mkdir -p /run/mysqld/ && chown -R mysql:mysql /var/run/mysqld && chmod 755 /var/run/mysqld
# RUN chown -R mysql:mysql /run/mysqld 
#RUN chown -R mysql:mysql /etc/mysqld
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/init_mariadb.sh /usr/local/bin/init_mariadb.sh
RUN chmod 777 /usr/local/bin/init_mariadb.sh
#COPY /home/lbouguet/Documents/inception_retry/requirements/srcs/.env /	
#RUN chown -R mysql:mysql /run/mysqld

EXPOSE 3306

CMD [ "/usr/local/bin/init_mariadb.sh" ]
#ENTRYPOINT ["mysqld", "&"]

