# 📦 Stack Docker – n8n + Traefik + Let's Encrypt

## 📁 Structure
- `/root/n8n/docker-compose.yml` : fichier de configuration principal
- `/root/n8n/n8n-data/` : données persistantes de n8n
- `/root/n8n/letsencrypt/` : certificats SSL Let's Encrypt générés par Traefik

## 🚀 Lancer ou redémarrer
```bash
cd /root/n8n
docker compose up -d
```

## 🛠 Scripts utiles

- `status-n8n.sh` : affiche l’état des conteneurs, ports, et logs
- `update-n8n.sh` : met à jour les images n8n + traefik

## 🌐 Domaine
- Adresse : https://n8n.stefi.ai
- Certificat SSL géré automatiquement par Traefik via Let's Encrypt

## 🔁 Mise à jour recommandée
```bash
./update-n8n.sh
```

## 🛑 Nettoyage en cas de souci
```bash
docker compose down
rm -rf ./letsencrypt
docker compose up -d
```
