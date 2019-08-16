# Gagarin Docker

Docker configuration for Gagarin project. Creates 3 containers:
- MySQL database
- Raketa back-end
- Gagarin front-end

## Requirements
- `docker`
- `docker-compose`

## Installation

```bash
# 1. Clone repository
git clone git@github.com:rvolny/gagarin-docker.git

# 2. Build images and run containers interactively
docker-compose up --build

# 3. When all containers are up and running, execute script to 
# initialise Raketa back-end. You only need to do this once. Do 
# not access Raketa back-end via web browser before you run this script.
# TODO: Have to do this better way
docker exec -it --user nginx gagarin-raketa /init.sh
```

## Re-create containers

If you wish to re-create containers from existing images.

```bash
docker-compose up -d
```

