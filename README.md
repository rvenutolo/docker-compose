# docker-compose

My Docker Compose files.

## Expected Environment Variables

- BACKUP_DIR
- DATA_DIR
- DOCKER_APP_DATA_DIR
- DOCKER_COMPOSE_DIR
- DOCKER_DIR
- DOCKER_LOGS_DIR
- DOCKER_NETWORK_CIDR
- DOCKER_SOCKET
- DOCKER_TZ
- DOMAIN_NAME
- DOMAIN_NAME_REGEX
- HOSTNAME
- PGID
- PUID
- TAILNET_IP
- USER

## Initialize

```shell
git clone git@github.com:rvenutolo/docker-compose.git ${DOCKER_DIR}
micro ${DOCKER_DIR}/managed-stacks
${DOCKER_DIR}/init
```
