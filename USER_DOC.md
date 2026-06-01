# User Documentation

This guide will help you understand, use, and manage the Inception project as an end user or administrator.

## Services Provided
Our infrastructure provides a complete, modern web stack hosted inside isolated Docker containers:
- **WordPress Website**: A fully functional content management system (CMS) where you can publish articles and manage a website.
- **MariaDB Database**: A secure database that stores all the content and settings for the WordPress site.
- **NGINX Web Server**: The main gateway that securely routes traffic (using HTTPS) to the WordPress site.
- **Adminer (Bonus)**: A lightweight, web-based database management tool to easily view and edit the database.
- **Static Website (Bonus)**: A simple HTML/CSS page showcasing additional web content.
- **Redis (Bonus)**: A caching service that makes the WordPress site load faster.
- **FTP Server (Bonus)**: A file transfer service to upload and manage files directly on the server.
- **Portainer (Bonus)**: A user-friendly web interface to manage and monitor all the Docker containers.

## Starting and Stopping the Project
We use a simple `Makefile` to manage the lifecycle of the project. Open your terminal in the root directory of the project:

- **To start the project:**
  Run `make up` or simply `make`. This will build all the services and start them in the background. It automatically creates the necessary folders for persistent data on your host machine.
  
- **To stop the project temporarily:**
  Run `make stop`. The containers will halt, but they won't be destroyed. You can start them again with `make start`.

- **To shut down the project:**
  Run `make down`. This stops and removes the containers and the internal network, but keeps your data safe.

## Accessing the Website and Administration Panels
Once the project is running, you can access the various services through your web browser. Make sure you accept the self-signed SSL certificates when prompted.

- **Main WordPress Website**: `https://cobussie.42.fr` (or `https://localhost` if you haven't set up the domain alias).
- **WordPress Admin Panel**: `https://cobussie.42.fr/wp-admin/`
- **Adminer (Database Manager)**: `http://localhost:8080` (or your domain on port 8080).
- **Static Site**: `http://localhost:8081`
- **Portainer (Docker Manager)**: `https://localhost:9443`

## Locating and Managing Credentials
For security reasons, passwords and sensitive information are not written directly into the configuration files. Instead, they are stored securely:

1. **Environment Variables**: Some non-critical configuration is stored in the `srcs/.env` file.
2. **Secrets**: Highly sensitive information (passwords, usernames) is kept in the `secrets/` directory at the root of the project. Each secret has its own text file (e.g., `db_password.txt`, `wp_admin_password.txt`).

**To manage credentials:**
- You can change the passwords by editing the text files inside the `secrets/` folder *before* starting the project for the first time, or by rebuilding the containers.
- If you need to log in to WordPress or Adminer, check the contents of the respective `.txt` files in the `secrets/` directory to retrieve the credentials.

## Checking Services are Running Correctly
To verify that everything is working as expected:
1. **Using the Terminal**:
   Run `docker ps` to see a list of all active containers. You should see containers for nginx, wordpress, mariadb, and any bonus services you have enabled. They should all have a status of "Up".
2. **Using Portainer**:
   Go to `https://localhost:9443`, create an admin account, and navigate to your local Docker environment. You will be able to see the status, logs, and resource usage of every container visually.
3. **Checking the Browser**:
   Simply try to access the WordPress site at `https://cobussie.42.fr`. If the page loads securely and without database connection errors, the core services are running correctly!
