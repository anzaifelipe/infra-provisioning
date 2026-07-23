#!/bin/bash
# Atualiza e instala o Docker
apt-get update -y
apt-get install -y ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update -y

apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

systemctl enable docker
usermod -aG docker ubuntu

# Instala o Git
apt-get install -y git

# Instala o Docker Compose
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Cria diretórios para volumes do TeamCity e buildagent
mkdir -p /home/ubuntu/teamcity/{agent_conf,bkp,data,datadir,logs}

# Cria o arquivo docker-compose.yaml
cat <<EOL > /home/ubuntu/teamcity/docker-compose.yaml
version: "3.8"
services:
  mssql:
    image: mcr.microsoft.com/mssql/server:2019-latest
    restart: unless-stopped
    container_name: sqlserver
    user: root
    ports:
      - 1433:1433
    environment:
      - ACCEPT_EULA=Y
      - SA_PASSWORD=${passdb}
      - MSSQL_PID=Express
    volumes:
      - ./data:/var/opt/mssql/data:rw
      - ./bkp:/var/opt/mssql/backups:rw
    networks:
      - tc

  server:
    container_name: server
    restart: unless-stopped
    image: jetbrains/teamcity-server:2024.07
    expose:
      - 8111
    networks:
      - tc
    depends_on:
      - traefik
    environment:
      - TZ=America/Sao_Paulo
    volumes:
      - ./datadir:/data/teamcity_server/datadir
      - ./logs:/opt/teamcity/logs
    labels:
      # SSL redirect requires a separate router (https://github.com/containous/traefik/issues/4688#issuecomment-477800500)
      - "traefik.http.routers.some-name.entryPoints=port80"
      - "traefik.http.routers.some-name.rule=host(`domain.com`)"
      - "traefik.http.middlewares.some-name-redirect.redirectScheme.scheme=https"
      - "traefik.http.middlewares.some-name-redirect.redirectScheme.permanent=true"
      - "traefik.http.routers.some-name.middlewares=some-name-redirect"
      # SSL endpoint
      - "traefik.http.routers.some-name-ssl.entryPoints=port443"
      - "traefik.http.routers.some-name-ssl.rule=host(`domain.com`)"
      - "traefik.http.routers.some-name-ssl.tls=true"
      - "traefik.http.routers.some-name-ssl.tls.certResolver=le-ssl"
      - "traefik.http.routers.some-name-ssl.service=some-name-ssl"
      - "traefik.http.services.some-name-ssl.loadBalancer.server.port=8111"

  agent:
    image: jetbrains/teamcity-agent:2024.07-linux-sudo
    container_name: agent
    restart: unless-stopped
    user: root
    privileged: true
    volumes:
      - ./agent_conf:/data/teamcity_agent/conf
    environment:
      - SERVER_URL=http://server:8111
      - DOCKER_IN_DOCKER=start
      - TZ=America/Sao_Paulo
    networks:
      - tc

  traefik:
    image: traefik:v2.3
    container_name: traefik
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
      # expose port below only if you need access to the Traefik API
      # - "8080:8080"
    command:
      #- "--log.level=DEBUG"
      #- "--api=true"
      - "--providers.docker=true"
      - "--entryPoints.port443.address=:443"
      - "--entryPoints.port80.address=:80"
      - "--certificatesResolvers.le-ssl.acme.tlsChallenge=true"
      - "--certificatesResolvers.le-ssl.acme.email=noreply@agilecontent.com"
      - "--certificatesResolvers.le-ssl.acme.storage=/letsencrypt/acme.json"
    volumes:
      - traefik-data:/letsencrypt/
      - /var/run/docker.sock:/var/run/docker.sock
    networks:
      - tc

networks:
  tc:
    driver: bridge

volumes:
  traefik-data:
EOL

sed -i '/traefik.http.routers.some-name.rule=host/c\      - "traefik.http.routers.some-name.rule=host(`${domain}`)"' /home/ubuntu/teamcity/docker-compose.yaml
sed -i '/traefik.http.routers.some-name-ssl.rule=host/c\      - "traefik.http.routers.some-name-ssl.rule=host(`${domain}`)"' /home/ubuntu/teamcity/docker-compose.yaml

# Define as permissões corretas para o diretório
chown -R ubuntu:ubuntu /home/ubuntu/teamcity

# Muda para o diretório do projeto e inicia o Docker Compose
cd /home/ubuntu/teamcity
docker-compose up -d