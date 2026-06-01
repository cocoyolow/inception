*This project has been created as part of the 42 curriculum by cobussie.*

## Description
The **Inception** project aims to broaden our knowledge of system administration by using Docker. You will virtualize several Docker images, creating them in your new personal virtual machine. The goal is to set up a small infrastructure composed of different services under specific rules, ensuring each service runs in its dedicated container.

## Project description

### Overview & Docker Usage
The infrastructure consists of several containers running isolated services:
- **NGINX**: Serves as the only entry point to our infrastructure, acting as a web server with TLS/SSL.
- **WordPress**: The website engine, running with PHP-FPM.
- **MariaDB**: The database engine, storing the WordPress data.

This project also includes several bonus services such as Redis (cache for WordPress), FTP server, Adminer (database management), a static website, and Portainer (container management). All of these are containerized using Docker, allowing us to maintain a clean host environment and manage services as self-contained, reproducible units. 

### Main Design Choices
- **Alpine/Debian Base Images**: Containers are built from scratch using minimal base images like Alpine Linux or Debian to keep the image footprint small and secure.
- **Container Isolation**: Each service runs in its own container, strictly adhering to the "one service per container" rule.
- **Custom Dockerfiles**: No pre-configured images are used (except for the OS). We write custom Dockerfiles to install and configure each service.
- **Makefile for Automation**: A Makefile is used to streamline the process of building, running, stopping, and cleaning the infrastructure.

### Architectural Comparisons

#### Virtual Machines vs Docker
- **Virtual Machines (VMs)** run a full guest operating system with virtualized hardware on top of a hypervisor. They are heavy, take minutes to boot, and consume significant resources.
- **Docker Containers** share the host system's kernel and isolate the application processes. They are lightweight, start in seconds, and require fewer resources, making them ideal for microservices.

#### Secrets vs Environment Variables
- **Environment Variables** are easy to use and configure but can be exposed to all processes within the container, visible in `docker inspect`, and may be accidentally logged.
- **Docker Secrets** provide a more secure way to inject sensitive data (like passwords) into containers. They are mounted as read-only files in an in-memory filesystem (tmpfs) within the container, reducing the risk of exposure.

#### Docker Network vs Host Network
- **Host Network** removes network isolation between the container and the Docker host. The container shares the host's networking namespace.
- **Docker Network (Bridge)** creates an isolated, internal network for containers. Containers on the same bridge network can communicate with each other using internal DNS names, but are isolated from external networks unless explicitly published via ports. Inception uses a custom bridge network for security.

#### Docker Volumes vs Bind Mounts
- **Bind Mounts** map an exact path on the host system to a path in the container. They rely on the host's filesystem structure and permissions.
- **Docker Volumes** are managed entirely by Docker and are stored in a dedicated directory on the host. They are the preferred mechanism for persisting data as they are decoupled from the specific host configuration, easier to back up, and safer for sharing among containers. In this project, we use bind mounts simulating local volumes (mapping to `/home/cobussie/data`).

## Instructions

### Prerequisites
- Docker and Docker Compose installed on your system.
- A user `cobussie` with a home directory.
- `make` utility.
- Secrets configured in the `secrets/` directory.

### Installation & Execution
1. Clone the repository and navigate to the project root.
2. Ensure your domain name (e.g., `cobussie.42.fr`) points to `127.0.0.1` in `/etc/hosts`.
3. Run the following command to build and launch the infrastructure:
   ```bash
   make
   ```
   Or specifically:
   ```bash
   make up
   ```
4. The services will be built and started in the background.

### Makefile Commands
This project relies on a Makefile to automate operations. Here is a list of all available commands:
- `make` or `make all`: Default target, builds and starts the whole infrastructure.
- `make up`: Executes the setup and launches the containers (`docker compose up -d --build`).
- `make setup`: Automatically creates the host directories required for data persistence.
- `make start`: Resumes stopped containers.
- `make stop`: Pauses/stops running containers without destroying them.
- `make down`: Stops and removes the containers and the Docker network.
- `make clean`: Runs `down` and removes unused Docker resources (system prune).
- `make fclean`: Runs `clean`, forcefully deletes the host data directories (losing all persistent data), and removes Docker volumes.
- `make re`: Completely wipes the infrastructure (`fclean`) and restarts it (`all`).

## Resources
- [Docker Documentation](https://docs.docker.com/)
- [NGINX Documentation](https://nginx.org/en/docs/)
- [WordPress Documentation](https://wordpress.org/support/)
- [MariaDB Knowledge Base](https://mariadb.com/kb/en/)

### AI Usage
AI tools were used during this project for:
- Structuring and drafting this documentation to ensure clarity and adherence to the required formats.
- Brainstorming the architectural comparisons (VMs vs Docker, Secrets vs Env, etc.) for accurate technical explanations.
