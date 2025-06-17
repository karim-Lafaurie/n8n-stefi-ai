#!/bin/bash

DOMAIN="n8n.stefi.ai"
EMAIL="contact@stefi.ai"
N8N_IMAGE="docker.n8n.io/n8nio/n8n:latest"
TRAEFIK_IMAGE="traefik:v3.0"

echo "➡️ Installation Docker, docker-compose et Certbot..."
apt update && apt install -y docker.io docker-compose certbot

echo "➡️ Création des dossiers nécessaires..."
mkdir -p /root/n8n/n8n-data /root/n8n/traefik

echo "➡️ Arrêt temporaire de Docker pour le SSL..."
systemctl stop docker
certbot certonly --standalone -d $DOMAIN --agree-tos --no-eff-email -m $EMAIL
systemctl start docker

echo "➡️ Création du fichier certs.yaml pour Traefik..."
cat > /root/n8n/traefik/certs.yaml <<EOF
tls:
  certificates:
    - certFile: "/etc/letsencrypt/live/$DOMAIN/fullchain.pem"
      keyFile: "/etc/letsencrypt/live/$DOMAIN/privkey.pem"
EOF

echo "➡️ Génération du docker-compose.yml..."
cat > /root/n8n/docker-compose.yml <<EOF
services:
  n8n:
    image: $N8N_IMAGE
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
      - "traefik.http.routers.n8n.service=n8n-srv"
      - "traefik.http.services.n8n-srv.loadbalancer.server.port=5678"

  traefik:
    image: $TRAEFIK_IMAGE
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

echo "➡️ Création du script de relance rapide : /root/start-n8n.sh"
cat > /root/start-n8n.sh <<EOF
#!/bin/bash
cd /root/n8n
docker compose up -d
EOF
chmod +x /root/start-n8n.sh

echo "➡️ Création du script de mise à jour : /usr/local/bin/update-n8n"
cat > /usr/local/bin/update-n8n <<'EOF'
#!/bin/bash
cd /root/n8n

VERSION=\${1:-latest}
echo "🔄 Mise à jour de n8n → version : \$VERSION"

docker pull docker.n8n.io/n8nio/n8n:\$VERSION
docker compose down
sed -i "s|image: docker.n8n.io/n8nio/n8n:.*|image: docker.n8n.io/n8nio/n8n:\$VERSION|" docker-compose.yml
docker compose up -d
docker exec n8n n8n --version
EOF
chmod +x /usr/local/bin/update-n8n

echo "➡️ Ajout du cron de renouvellement SSL..."
(crontab -l 2>/dev/null; echo "0 3 * * * certbot renew --quiet && docker restart traefik") | crontab -

echo "✅ Lancement de la stack Docker..."
cd /root/n8n
docker compose up -d

echo "🎉 Installation terminée : https://$DOMAIN"
echo "➡️ Pour mettre à jour n8n : sudo update-n8n [version]"
echo "➡️ Pour relancer manuellement : /root/start-n8n.sh"