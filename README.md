# Docker Compose Development Stack

This repository contains Docker Compose configurations for a comprehensive development stack including databases, AI services, and web interfaces.

## Overview

This project provides a ready-to-use development environment with the following components:
- PostgreSQL databases (regular and vector-enabled)
- Redis cache with RedisInsight
- Ollama AI model server with ROCm support
- Open WebUI for AI model interaction
- pgAdmin for database management

## Quick Start

1. Navigate to the stack directory:
   ```bash
   cd stack/
   ```

2. Start all services:
   ```bash
   docker compose up -d
   ```

3. Access the services:
   - **Open WebUI**: http://localhost:3000 (AI chat interface)
   - **pgAdmin**: http://localhost:80 (Database administration)
   - **RedisInsight**: http://localhost:5540 (Redis management)

## Structure

```
├── README.md           # This file
└── stack/             # Docker Compose stack
    ├── compose.yml    # Main Docker Compose configuration
    ├── update-ollama-models.sh  # Script to update AI models
    └── README.md      # Detailed stack documentation
```

## Features

- **AI Development**: Ollama server with AMD ROCm GPU support
- **Database Development**: PostgreSQL with pgvector extension for AI/ML workloads
- **Caching**: Redis with web-based management interface
- **Web Interface**: Modern UI for interacting with AI models
- **Data Persistence**: All data is persisted in Docker volumes

## Requirements

- Docker and Docker Compose
- For GPU acceleration: AMD GPU with ROCm drivers
- Sufficient disk space for AI models and databases

## Management

See the `stack/` directory for detailed documentation on managing individual services, updating AI models, and configuration options.
