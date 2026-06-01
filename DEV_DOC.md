# Developer Documentation

This document outlines how to set up, build, and manage the Inception project from a developer's perspective.

## Setting Up the Environment from Scratch

### Prerequisites
- A Linux environment (or a Virtual Machine) running Debian or Alpine.
- **Docker** Engine installed.
- **Docker Compose** plugin installed.
- **Make** utility installed.
- Sudo privileges (required for directory creation and removal in the `Makefile`).

### Domain Configuration
The project requires the main service to be accessible via `login.42.fr`. You must update your local hosts file to route this domain to your localhost:
```bash
sudo nano /etc/hosts
```
Add the following line:
```text
127.0.0.1   cobussie.42.fr
```

### Secrets and Configuration Files
Before building the project, you must ensure that all environment variables and secrets are in place.

1. **.env File**: Ensure there is a `.env` file inside the `srcs/` directory containing environment configurations (like the domain name).
2. **Secrets Directory**: Create a `secrets/` directory at the root of the project (if not present) and populate it with the required `.txt` files containing credentials. The required secrets (as per `docker-compose.yml`) are:
   - `db_user.txt`, `db_password.txt`, `db_root_password.txt`
   - `wp_admin_user.txt`, `wp_admin_password.txt`, `wp_admin_email.txt`
   - `wp_user.txt`, `wp_user_password.txt`, `wp_user_email.txt`
   - `ftp_user.txt`, `ftp_password.txt`
   - `portainer_password.txt`

Make sure to fill these files with strong, secure values.

## Building and Launching the Project

We use a `Makefile` situated at the root to abstract Docker Compose commands and manage data directories.

- **To build and launch everything**:
  ```bash
  make up
  ```
  This command will:
  1. Trigger the `setup` rule to create local directories for persistent data (`/home/cobussie/data/mariadb` and `/home/cobussie/data/wordpress`).
  2. Navigate to the `srcs/` directory and execute `docker compose up -d --build`.
  3. Docker Compose will parse `docker-compose.yml`, read the `.env` file and secrets, build all images from their respective `requirements/*/Dockerfile`, and launch the containers in detached mode.

## Managing Containers and Volumes

### Useful Makefile Commands
- `make stop`: Pauses all running containers (`docker compose stop`).
- `make start`: Resumes paused containers (`docker compose start`).
- `make down`: Stops and removes all containers and the custom network (`docker compose down`).
- `make clean`: Performs a `down` and also removes all unused images, networks, and anonymous volumes (`docker system prune -a -f`).
- `make fclean`: Performs a `clean`, forcefully removes the host data directories (`sudo rm -rf /home/cobussie/data`), and prunes all volumes (`docker system prune --volumes -f`). **Use with caution!**

### Manual Docker Commands
If you need to debug a specific service, you can use native Docker commands:
- View live logs of a service: `docker compose -f srcs/docker-compose.yml logs -f <service_name>`
- Access a running container's shell: `docker exec -it <container_name> /bin/bash` (or `/bin/sh` if Alpine).
- Inspect container properties: `docker inspect <container_name>`

## Data Storage and Persistence

By design, Docker containers are ephemeral. To ensure that our database and website files survive container restarts and rebuilds, we use volumes mapped to local directories on the host.

- **How it works**: In `srcs/docker-compose.yml`, we define volumes using the `local` driver with the `bind` option. This maps a specific path on the host machine to a directory inside the container.
- **Where data is stored on the host**: All persistent data is stored under `/home/cobussie/data`.
  - **MariaDB Data**: Stored in `/home/cobussie/data/mariadb`. This maps to `/var/lib/mysql` inside the `mariadb` container.
  - **WordPress Data**: Stored in `/home/cobussie/data/wordpress`. This maps to `/var/www/html` inside the `wordpress` container, as well as being shared with the `nginx` and `ftp` containers.

Because the data is mounted as a bind mount, completely destroying the containers (e.g., via `make down` or `make clean`) will **not** delete the data. The only way to erase the persistent data is to manually delete the `/home/cobussie/data` directory (which is what `make fclean` does).
