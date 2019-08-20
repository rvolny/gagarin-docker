# Gagarin Docker

Docker configuration for Gagarin project. Creates 3 containers:
- MySQL database
- Raketa back-end
- Gagarin front-end

## Requirements
- `docker`
- `docker-compose`

## Installation

1. Clone repository

   ```bash
   git clone git@github.com:rvolny/gagarin-docker.git
   ```

2. Create .env file

   ```bash
   cp .env.example .env
   ```

3. Setup environment  and replace all `___REPLACE___` strings with your values.

   1. MYSQL_PASSWORD - application password
   2. MYSQL_ROOT_PASSWORD - root password to setup database and grant privileges
   3. DATA_PATH_HOST - local path to persistent MySQL data
   4. MDBVUE_PASSWORD - git token to mdbvue repository

4. Build images and run containers interactively

   ```bash
   docker-compose up --build
   ```

5. When all containers are up and running, execute script to initialize Raketa back-end. You only need to do this once. Do not access Raketa back-end via web browser before you run this script. **TODO**: Do this better way.

   ```bash
   docker exec -it --user nginx gagarin-raketa /init.sh
   ```

## Re-create containers

If you wish to start existing containers run:

```bash
docker-compose up -d
```

If you also deleted persistent database files, run `/init.sh` again.

