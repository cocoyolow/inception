NAME		= inception
COMPOSE		= cd srcs && docker compose
DATA_PATH	= /home/cobussie/data

all: $(NAME)

$(NAME): up


up: setup
	$(COMPOSE) up -d --build

setup:
	@mkdir -p $(DATA_PATH)
	@mkdir -p $(DATA_PATH)/mariadb
	@mkdir -p $(DATA_PATH)/wordpress

stop:
	$(COMPOSE) stop

start:
	$(COMPOSE) start

down:
	$(COMPOSE) down

clean:
	$(COMPOSE) down -v
	@docker system prune -a -f


fclean: clean
	@sudo rm -rf $(DATA_PATH)
	@docker system prune --volumes -f

re: fclean all

.PHONY: all setup up stop start down clean fclean re inception