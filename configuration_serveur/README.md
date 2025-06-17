🚀 Déploiement automatique de n8n avec Traefik et SSL Let’s Encrypt

Ce dépôt contient un script d’installation (setup-n8n.sh) qui permet de configurer automatiquement un serveur n8n auto-hébergé avec :
	•	Docker & Docker Compose
	•	n8n (éditeur de workflows)
	•	Traefik (reverse proxy HTTPS)
	•	Certificat SSL Let’s Encrypt valide
	•	Cron pour le renouvellement automatique du certificat
	•	Script de relance rapide
	•	Script de mise à jour automatique de n8n (update-n8n)

⸻

🧰 Prérequis
	•	Un VPS (ex : Hostinger KVM2)
	•	Ubuntu 22.04 ou 24.04
	•	Accès root SSH
	•	Le sous-domaine n8n.stefi.ai doit pointer vers l’IP du VPS via un enregistrement DNS A

⸻

📂 Contenu du dépôt
	•	setup-n8n.sh : script d’installation automatisée
	•	start-n8n.sh : script de relance manuelle de la stack
	•	update-n8n : script de mise à jour automatique de n8n (inclut la version ciblée en argument)

⸻

🛠️ Étapes à suivre

1. Copier le script d’installation sur le VPS

Depuis votre machine locale :

scp setup-n8n.sh root@46.202.168.59:/root/

2. Se connecter au serveur

ssh root@46.202.168.59

3. Exécuter le script

chmod +x /root/setup-n8n.sh
./setup-n8n.sh

Une fois l’installation terminée, l’interface sera accessible sur :
👉 https://n8n.stefi.ai

⸻

🔁 Relancer manuellement les services

/root/start-n8n.sh


⸻

🔄 Mettre à jour n8n

Vers la dernière version stable :

sudo update-n8n

Vers une version précise :

sudo update-n8n 1.98.1

Le script gère le pull, le redéploiement, et affiche la version en sortie.

⸻

⚙️ Mettre à jour Traefik

Vers la dernière version stable :

docker pull traefik:v3.0
cd /root/n8n
docker compose up -d traefik

Vers une version précise :

# Modifier le fichier docker-compose.yml :
image: traefik:v3.4.1
# Puis :
docker compose up -d traefik


⸻

📊 Interface Traefik (optionnel)

Créer un sous-domaine : traefik.stefi.ai pointant vers ton VPS.

Ajouter dans docker-compose.yml sous traefik: :

labels:
  - "traefik.http.routers.dashboard.rule=Host(`traefik.stefi.ai`)"
  - "traefik.http.routers.dashboard.service=api@internal"
  - "traefik.http.routers.dashboard.entrypoints=websecure"
  - "traefik.http.routers.dashboard.tls=true"


⸻

🛡️ Renouvellement automatique du certificat

Déjà prévu dans le cron :

0 3 * * * certbot renew --quiet && docker restart traefik


⸻

🧼 Nettoyage en cas de conflit (port 80/443 ou router dupliqué)

lsof -i :80
kill -9 <PID1> <PID2>

# ou via Docker :
docker ps -a
# identifier et supprimer les doublons

docker rm -f <nom_du_conteneur>
docker image prune -f

Puis relancer :

cd /root/n8n
docker compose down && docker compose up -d


⸻

✅ Déploiement réussi
	•	Accès n8n : https://n8n.stefi.ai
	•	Mise à jour : update-n8n [version]
	•	Relance : /root/start-n8n.sh
	•	Traefik dashboard (optionnel) : https://traefik.stefi.ai

Document mis à jour : juin 2025