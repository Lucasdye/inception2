# Define variables
COMPOSE=sudo docker-compose
COMPOSE_FILE=srcs/docker-compose.yml

# Target to build and start the Docker containers
all: makedir build up

# Default target: display help message
help:
	@echo "Usage: make <target>"
	@echo "Targets:"
	@echo "  all			 Build and start the Docker containers"
	@echo "  build           Build the Docker containers"
	@echo "  up              Start the Docker containers"
	@echo "  down            Stop and remove the Docker containers"
	@echo "  clean           Stop and remove containers, networks, and volumes"
	@echo "  ps              List running containers"
	@echo "  logs            Show logs of the containers"

makedir:
	mkdir -p /home/lbouguet/data/mariadb
	mkdir -p /home/lbouguet/data/wordpress

# Target to build the Docker containers
build:
	$(COMPOSE) -f $(COMPOSE_FILE) build
	

# Target to start the Docker containers
up:
	$(COMPOSE) -f $(COMPOSE_FILE) up -d
	sudo docker cp nginx:etc/nginx/ssl/inception.crt /usr/local/share/ca-certificates
	sudo docker cp nginx:etc/nginx/ssl/inception.key /usr/local/share/ca-certificates

# Target to stop and remove the Docker containers
down:
	$(COMPOSE) -f $(COMPOSE_FILE) down

reimport_ca:
	sudo rm -rf /usr/local/share/ca-certificates/inception.crt
	sudo rm -rf /usr/local/share/ca-certificates/inception.key

rm_images:
	sudo docker rmi $$(sudo docker images -aq)

clean_volumes: down
	sudo docker volume rm -rf $$()
	sudo rm -rf /home/lbouguet/data/mariadb /home/lbouguet/data/wordpress

# Target to clean up containers, networks, and volumes
clean:
	$(COMPOSE) -f $(COMPOSE_FILE) down --volumes --remove-orphans
	@echo "All containers are stopped."

# Target to clean up all containers, images, networks, and volumes
fclean: clean
	@sudo docker system prune -af
#	@-sudo docker rm $$(sudo docker volume ls -q)
	@sudo rm -rf /home/lbouguet/data/mariadb /home/lbouguet/data/wordpress
#	@-sudo docker rmi $$(sudo docker image ls -aq)
#	@echo "All images and containers are cleared."

# Target to list running containers
ps:
	$(COMPOSE) -f $(COMPOSE_FILE) ps

# Target to clean and build + start the Docker containers
re: clean all

# Target to show logs of the containers
logs:
	$(COMPOSE) -f $(COMPOSE_FILE) logs -f

.PHONY: build up all logs re clean fclean down makedir