#!/bin/bash

DOMAIN="n8n.stefi.ai"
EMAIL="contact@stefi.ai"

echo "➡️ Installation Docker & Certbot..."
apt update && apt install -y docker.io docker-compose certbot

echo "➡️ Création des dossiers..."
mkdir -p /root/n8n/n8n-data /root/n8n/traefik

echo "➡️ Génération du certificat SSL avec Certbot..."
systemctl stop docker
certbot certonly --standalone -d $DOMAIN --agree-tos --no-eff-email -m $EMAIL
systemctl start docker

echo "➡️ Création du fichier certs.yaml..."
cat > /root/n8n/traefik/certs.yaml <<EOF
tls:
  certificates:
    - certFile: "/etc/letsencrypt/live/$DOMAIN/fullchain.pem"
      keyFile: "/etc/letsencrypt/live/$DOMAIN/privkey.pem"
EOF

echo "➡️ Création de docker-compose.yml..."
cat > /root/n8n/docker-compose.yml <<EOF
services:
  n8n:
    image: docker.n8n.io/n8nio/n8n
    container_name: n8n
    restart: always
    environment:
      - N8N_HOST=$DOMAIN
      - N8N_PORT=5678
      - N8N_PROTOCOL=http
      - WEBHOOK_URL=https://$DOMAIN/
      - TZ=Europe/Paris
    volumes:
      - ./n8n-data:/home/node/.n8n
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.n8n.rule=Host(\`$DOMAIN\`)"
      - "traefik.http.routers.n8n.entrypoints=websecure"
      - "traefik.http.routers.n8n.tls=true"
      - "traefik.http.services.n8n.loadbalancer.server.port=5678"

  traefik:
    image: traefik:latest
    container_name: traefik
    restart: always
    command:
      - "--api.dashboard=true"
      - "--entrypoints.web.address=:80"
      - "--entrypoints.websecure.address=:443"
      - "--providers.docker=true"
      - "--providers.docker.exposedbydefault=false"
      - "--providers.file.filename=/etc/traefik/certs.yaml"
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /etc/letsencrypt:/etc/letsencrypt:ro
      - ./traefik/certs.yaml:/etc/traefik/certs.yaml
EOF

echo "➡️ Script de relance rapide créé."
cat > /root/start-n8n.sh <<EOF
#!/bin/bash
cd /root/n8n
docker compose up -d
EOF
chmod +x /root/start-n8n.sh

echo "➡️ Ajout d'un cron pour le renouvellement automatique du certificat..."
(crontab -l 2>/dev/null; echo "0 3 * * * certbot renew --quiet && docker restart traefik") | crontab -

echo "✅ Déploiement de n8n..."
cd /root/n8n
docker compose up -d
