GREEN := \033[1;32m
RED := \033[1;31m
LIGHT_GREEN := \033[1;92m
RESET := \033[0m
YELLOW := \033[1;33m


all: up


up:
	@echo "$(GREEN)Starting the containers...$(RESET)"
	@mkdir -p /home/oettaqui/data/wordpress
	@mkdir -p /home/oettaqui/data/mariadb
	docker compose -f srcs/docker-compose.yml  up --build -d
	@echo "$(LIGHT_GREEN)Containers started successfully!$(RESET)"

down:
	@echo "$(RED)Stopping the containers...$(RESET)"
	docker compose -f srcs/docker-compose.yml  down
	@echo "$(RED)Containers stopped successfully!$(RESET)"

stop:
	@echo "$(RED)Stopping the containers...$(RESET)"
	docker compose -f srcs/docker-compose.yml  stop
	@echo "$(RED)Containers stopped successfully!$(RESET)"

start:
	@echo "$(GREEN)Starting the containers...$(RESET)"
	docker compose -f srcs/docker-compose.yml  start
	@echo "$(LIGHT_GREEN)Containers started successfully!$(RESET)"

status:
	@echo "$(GREEN)Containers status...$(RESET)"
	@clear
	@echo "\n$(YELLOW)CONTAINERS$(RESET)\n"
	@docker ps -a
	@echo "\n$(YELLOW)IMAGES$(RESET)\n"
	@docker image ls
	@echo "\n$(YELLOW)VOLUMES$(RESET)\n"
	@docker volume ls
	@echo ""


clean:
	@echo "$(RED)Cleaning the containers...$(RESET)"
	@docker compose -f srcs/docker-compose.yml down
	@docker rmi -f `docker images -q`
	@docker volume rm `docker volume ls -q`

	@echo "$(RED)Containers cleaned successfully!$(RESET)"

fclean:clean
	@echo "$(RED)Removing all docker images...$(RESET)"
	@sudo rm -rf /home/oettaqui/data/wordpress
	@sudo rm -rf /home/oettaqui/data/mariadb
	@docker system prune -fa
	@docker volume prune -f
	@echo "$(RED)All docker images removed!$(RESET)"



re: fclean all

.PHONY: all down re clean