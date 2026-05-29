NAME		= inception
COMPOSE		= cd srcs && docker compose
DATA_PATH	= /home/cobussie/data

all: $(NAME)

$(NAME): setup
	$(COMPOSE) up -d --build

setup:
	@mkdir -p $(DATA_PATH)/mariadb
	@mkdir -p $(DATA_PATH)/wordpress
	@echo "Dossiers de données créés dans $(DATA_PATH)"

# Lancer les conteneurs (sans les reconstruire)
up: setup
	$(COMPOSE) up -d

stop:
	$(COMPOSE) stop

start:
	$(COMPOSE) start

down:
	$(COMPOSE) down

# Nettoyage des conteneurs, réseaux et volumes Docker
clean:
	$(COMPOSE) down -v

fclean: clean
	@sudo rm -rf $(DATA_PATH)/mariadb/*
	@sudo rm -rf $(DATA_PATH)/wordpress/*
	@sudo rm -rf $(DATA_PATH)
	@docker system prune -a --volumes -f

re: fclean all

.PHONY: all setup up stop start down clean fclean re