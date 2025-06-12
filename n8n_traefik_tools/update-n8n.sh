#!/bin/bash
echo "⬇️ Mise à jour des images n8n & traefik..."
cd /root/n8n || exit 1

docker compose pull
docker compose down
docker compose up -d

echo "✅ Mise à jour terminée."
