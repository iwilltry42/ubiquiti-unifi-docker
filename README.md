# Ubiquiti Unifi - Docker Image

This repo packages the Unifi controller (Web Interface) in a Docker container.
The docker-compose file and configurations are setup to use an external MongoDB database.

## Usage

1. `docker-compose up -d`
2. Access `https://localhost:8443` to get to the Unifi Web-UI

## Development

### Overview

- MongoDB:
  - init script(s) located in [`./mongo/docker-entrypoint-initdb.d/`](./mongo/docker-entrypoint-initdb.d/)
    - mounted into the container at runtime (docker-compose volume mount)
- MongoDB-Express
  - web interface for MongoDB (optional)
- Unifi
  - Extra configuration (for the external database) via `system.properties` file that is generated using `confd`

## To-Do

- [ ] Proper log handling -> stream logs from multiple files to stdout in unifi container
