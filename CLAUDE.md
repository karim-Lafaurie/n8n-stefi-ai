# CLAUDE.md 

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository contains n8n workflow automation configurations for the "Stefi.ai" project. It's focused on deploying and managing n8n (workflow automation platform) with automated server setup and research workflows that integrate with Perplexity AI.

## Key Components

### Server Infrastructure (`configuration_serveur/`)
- **setup-n8n.sh**: Automated deployment script for n8n with Docker, Traefik reverse proxy, and Let's Encrypt SSL certificates
- **Domain**: Configured for `n8n.stefi.ai`
- **Email**: Uses `contact@stefi.ai` for SSL certificates

### n8n Workflows
- **stefi-ai - MaCommune.json**: Main workflow for article generation from Perplexity research
- **perplexity-example.json**: Complex workflow that performs topic research, HTML article generation with TailwindCSS styling
- **recherche-perplexity.json**: Sub-workflow for Perplexity API research calls

## Common Development Tasks

### Server Deployment
```bash
# Copy setup script to VPS
scp setup-n8n.sh root@<IP_DU_SERVEUR>:/root/

# Execute on server
chmod +x /root/setup-n8n.sh
./setup-n8n.sh

# Restart services if needed
/root/start-n8n.sh
```

### Workflow Management
- Workflows are stored as JSON files containing n8n node configurations
- Main workflow creates articles from Perplexity research with HTML/TailwindCSS output
- Uses OpenAI GPT-4o-mini for content processing and generation
- Integrates with Perplexity API for research data

## Architecture Notes

### n8n Configuration
- **Port Configuration**: n8n runs on port 5678 internally, exposed via Traefik on ports 80/443
- **SSL**: Automated Let's Encrypt certificates with auto-renewal via cron
- **Timezone**: Configured for Europe/Paris
- **Domain**: All services accessible at https://n8n.stefi.ai

### Workflow Structure
- Webhook-triggered workflows for external API access
- Multi-stage article processing: research → JSON extraction → HTML generation → TailwindCSS styling
- Error handling with conditional logic nodes
- Integration with OpenAI API (requires API credentials)
- Perplexity API integration for research capabilities

### API Dependencies
- OpenAI API (GPT-4o-mini model)
- Perplexity AI API (llama-3.1-sonar-small-128k-online model)
- Webhook endpoints for external integrations

## Important Paths and URLs
- **Production URL**: https://n8n.stefi.ai
- **Webhook Path**: `/pblog` (for article generation workflow)
- **SSL Certificates**: `/etc/letsencrypt/live/n8n.stefi.ai/`
- **n8n Data**: `/root/n8n/n8n-data`
- **Docker Compose**: `/root/n8n/docker-compose.yml`