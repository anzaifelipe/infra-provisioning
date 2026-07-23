#!/bin/bash
yum install -y docker
service docker start
usermod -a -G docker ec2-user
chkconfig docker on
yum install -y git
curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
git clone https://${git_username}:${git_token}@github.com/agilecontent/devops-utils.git /home/ec2-user/devops-utils
chown ec2-user:ec2-user -R /home/ec2-user/devops-utils/
docker volume create --name=prometheus-volume
docker volume create --name=grafana-volume
docker volume create --name=uptime-kuma
touch /home/ec2-user/devops-utils/monitor-stack-updated/.env
echo "PROFILES=default" >> /home/ec2-user/devops-utils/monitor-stack-updated/.env
echo "ACCESS_KEY_ID=${access_key}" >> /home/ec2-user/devops-utils/monitor-stack-updated/.env
echo "SECRET_ACCESS_KEY=${secret_key}" >> /home/ec2-user/devops-utils/monitor-stack-updated/.env
echo "REGION=${aws_region}" >> /home/ec2-user/devops-utils/monitor-stack-updated/.env
echo "CADDY_ADMIN_USER=${caddy_user}" >> /home/ec2-user/devops-utils/monitor-stack-updated/.env
echo "CADDY_ADMIN_PASSWORD=${caddy_password}" >> /home/ec2-user/devops-utils/monitor-stack-updated/.env
sed -i '/devops.teste.agilesvcs.com/c\domain = ${domain}' /home/ec2-user/devops-utils/monitor-stack-updated/grafana/conf/defaults.ini
sed -i '/devops.teste_root.agilesvcs.com/c\root_url = https://${domain}' /home/ec2-user/devops-utils/monitor-stack-updated/grafana/conf/defaults.ini
sed -i '/traefik.http.routers.some-name.rule=host/c\      - "traefik.http.routers.some-name.rule=host(`${domain}`)"' /home/ec2-user/devops-utils/monitor-stack-updated/docker-compose.yml
sed -i '/traefik.http.routers.some-name-ssl.rule=host/c\      - "traefik.http.routers.some-name-ssl.rule=host(`${domain}`)"' /home/ec2-user/devops-utils/monitor-stack-updated/docker-compose.yml
sed -i '/VIRTUAL_HOST=devops.prometheus.teste.agilesvcs.com/c\      - VIRTUAL_HOST=${domain}' /home/ec2-user/devops-utils/monitor-stack-updated/docker-compose.yml
sed -i '/LETSENCRYPT_HOST=devops.prometheus.teste.agilesvcs.com/c\      - LETSENCRYPT_HOST=${domain}' /home/ec2-user/devops-utils/monitor-stack-updated/docker-compose.yml
sed -i '/traefik.http.routers.influxdb.rule=host/c\      - "traefik.http.routers.influxdb.rule=host(`${domain}`)"' /home/ec2-user/devops-utils/monitor-stack-updated/docker-compose.yml
sed -i '/traefik.http.routers.prometheus.rule=host/c\      - "traefik.http.routers.prometheus.rule=host(`${domain}`)"' /home/ec2-user/devops-utils/monitor-stack-updated/docker-compose.yml
sed -i '/traefik.http.routers.alertmanager.rule=host/c\      - "traefik.http.routers.alertmanager.rule=host(`${domain}`)"' /home/ec2-user/devops-utils/monitor-stack-updated/docker-compose.yml
sed -i '/traefik.http.routers.kuma.rule=host/c\      - "traefik.http.routers.kuma.rule=host(`${domain}`)"' /home/ec2-user/devops-utils/monitor-stack-updated/docker-compose.yml
docker-compose -f /home/ec2-user/devops-utils/monitor-stack-updated/docker-compose.yml up -d