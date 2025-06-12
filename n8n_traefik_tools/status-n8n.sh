#!/bin/bash
echo "🔍 État des conteneurs n8n & traefik :"
docker ps --filter "name=n8n" --filter "name=traefik"

echo -e "\n🧪 Vérification des ports exposés :"
docker ps --format "table {{.Names}}	{{.Ports}}" | grep -E "n8n|traefik"

echo -e "\n📜 Dernières lignes des logs Traefik :"
docker logs traefik --tail 20
