
ARGS?=
# add -it to ARGS to run interactively

build_nginx:
	@docker build -t nginx srcs/requierements/nginx/

run_nginx:
	@docker run $(ARGS) nginx
show_images:
	@docker image ls

show_running:
	@docker ps