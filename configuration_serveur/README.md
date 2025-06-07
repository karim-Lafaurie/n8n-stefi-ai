# Déploiement automatique de n8n avec Traefik et SSL Let's Encrypt

Ce dépôt contient un script d'installation (`setup-n8n.sh`) qui permet de configurer automatiquement un serveur n8n auto-hébergé avec :

- Docker & Docker Compose
- n8n (éditeur de workflows)
- Traefik (reverse proxy)
- Certificat SSL Let's Encrypt valide
- Cron pour le renouvellement automatique du certificat
- Script de relance rapide

---

## 🧰 Prérequis

- Un VPS (ex: Hostinger KVM2)
- Ubuntu 22.04 ou 24.04
- Accès root SSH
- Le sous-domaine `n8n.stefi.ai` doit pointer vers l'IP du VPS via un enregistrement DNS A

---

## 🚀 Étapes à suivre

### 1. Copier le script d'installation sur le VPS

Depuis votre machine locale :

```bash
scp setup-n8n.sh root@<IP_DU_SERVEUR>:/root/
```

### 2. Se connecter au serveur

```bash
ssh root@<IP_DU_SERVEUR>
```

### 3. Exécuter le script

```bash
chmod +x /root/setup-n8n.sh
./setup-n8n.sh
```

Cela prend quelques minutes. Une fois terminé, l'interface sera accessible sur :

👉 https://n8n.stefi.ai

---

## 🔁 Redémarrer les services n8n/traefik si nécessaire

```bash
/root/start-n8n.sh
```

---

## 🛡️ Renouvellement automatique du certificat

Le script configure un cron pour renouveler le certificat tous les jours à 3h :

```
0 3 * * * certbot renew --quiet && docker restart traefik
```

---

## 🧼 Nettoyage du port 80 (si conflit)

Si le port 80 est bloqué par un vieux processus docker :

```bash
lsof -i :80
kill -9 <PID1> <PID2>
```

Puis relancer :

```bash
docker compose down
docker compose up -d
```

---

## 🧩 Prochaines idées

- Ajouter un backup automatique des données
- Activer la protection par mot de passe sur l'accès à n8n
- Interface admin Traefik sur un sous-domaine (`traefik.stefi.ai`)
