# Stefi.ai - n8n Workflow Automation

Ce repository contient les configurations de workflows n8n pour le projet Stefi.ai, une plateforme d'automatisation pour la génération d'articles et la recherche d'informations municipales.

## 🚀 Aperçu du Projet

Stefi.ai utilise n8n (workflow automation platform) pour automatiser la recherche et la génération de contenu en intégrant :
- **Perplexity AI** pour la recherche d'informations
- **OpenAI GPT-4o-mini** pour la génération de contenu
- **Traefik** comme reverse proxy avec SSL automatique

## 📁 Structure du Projet

```
├── configuration_serveur/     # Scripts de déploiement serveur
├── Flow-MaCommune/           # Workflows spécifiques MaCommune
├── n8n_traefik_tools/        # Outils Traefik pour n8n
├── *.json                    # Workflows n8n exportés
├── prompt.md                 # Prompts pour les IA
└── CLAUDE.md                 # Documentation technique
```

## 🛠️ Workflows Principaux

### 1. **stefi-ai - MaCommune.json**
Workflow principal pour la génération d'articles analysant les communes françaises dans le cadre des élections municipales de 2026.

### 2. **perplexity-example.json**
Workflow complexe de recherche et génération d'articles HTML avec styling TailwindCSS.

### 3. **recherche-perplexity.json**
Sub-workflow spécialisé dans les appels API vers Perplexity.

### 4. **dossier-municipal-*.json**
Workflows pour l'analyse exhaustive des données municipales.

## 🔧 Installation et Déploiement

### Prérequis
- Docker et Docker Compose
- Nom de domaine configuré (ex: `n8n.stefi.ai`)
- Clés API pour OpenAI et Perplexity

### Déploiement Automatique
```bash
# Copier le script sur votre serveur
scp configuration_serveur/setup-n8n.sh root@<IP_SERVEUR>:/root/

# Exécuter l'installation
chmod +x /root/setup-n8n.sh
./setup-n8n.sh
```

### Configuration Manuelle
1. Configurer les variables d'environnement
2. Importer les workflows JSON dans n8n
3. Configurer les webhooks et les clés API

## 🌐 Accès

- **URL Production** : https://n8n.stefi.ai
- **Webhook Principal** : `/pblog` (génération d'articles)
- **Port n8n** : 5678 (interne), 80/443 (externe via Traefik)

## 🔑 APIs Intégrées

- **OpenAI API** : Modèle GPT-4o-mini pour la génération de contenu
- **Perplexity AI** : Modèle llama-3.1-sonar-small-128k-online pour la recherche
- **Webhooks** : Points d'entrée pour intégrations externes

## 📊 Fonctionnalités

### Analyse Municipale
- Extraction automatique des données INSEE
- Analyse des finances communales
- Recherche d'actualités locales
- Génération de rapports électoraux

### Génération de Contenu
- Articles HTML avec styling TailwindCSS
- Analyses stratégiques pour candidats municipaux
- Synthèses automatisées de données publiques

## 🛡️ Sécurité

- Certificats SSL Let's Encrypt avec renouvellement automatique
- Configuration Traefik sécurisée
- Gestion des secrets via variables d'environnement

## 📝 Version n8n

**Version utilisée** : 1.97

⚠️ **Important** : Les workflows sont optimisés pour n8n 1.97. Vérifiez la compatibilité avant mise à jour.

## 🤝 Contribution

1. Forkez le repository
2. Créez une branche feature (`git checkout -b feature/nouvelle-fonctionnalite`)
3. Committez vos changements (`git commit -am 'Ajout nouvelle fonctionnalité'`)
4. Poussez vers la branche (`git push origin feature/nouvelle-fonctionnalite`)
5. Créez une Pull Request

## 📞 Support

Pour toute question ou support :
- Email : contact@stefi.ai
- Documentation technique : Voir `CLAUDE.md`

## 📄 Licence

Ce projet est sous licence privée. Tous droits réservés.

---

**Fait avec ❤️ pour automatiser l'analyse politique locale** 