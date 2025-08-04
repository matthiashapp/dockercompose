# Docker Compose Stack

This directory contains a comprehensive Docker Compose stack for development with AI, databases, and web services.

## Services

### AI & Machine Learning
- **Ollama** (`ollama`): AI model server with AMD ROCm GPU support
  - Port: 11434
  - Image: `ollama/ollama:0.10.1-rocm`
  - GPU devices: `/dev/kfd`, `/dev/dri`
  - Volume: `ollama` (model storage)

- **Open WebUI** (`owu`): Modern web interface for AI models
  - Port: 3000 → 8080
  - Image: `ghcr.io/open-webui/open-webui:v0.6.18`
  - Volume: `open-webui` (user data)

### Databases
- **PostgreSQL** (`p17`): Main database server
  - Port: 5432
  - Image: `postgres:17.5-bookworm`
  - Database: `vision`
  - Credentials: `postgres/password`
  - Volume: `postgres_data`

- **pgVector** (`pgv`): PostgreSQL with vector extension for AI/ML
  - Port: 5433 → 5432
  - Image: `pgvector/pgvector:0.8.0-pg17`
  - Credentials: `postgres/password`
  - Volume: `pgvector17_data`

- **pgAdmin** (`pga`): Database administration interface
  - Port: 80
  - Image: `dpage/pgadmin4:9.6.0`
  - Login: `postgres@asdf.de/password`
  - Volume: `pgadmin`

### Caching & Memory Store
- **Redis** (`r8`): In-memory data store
  - Port: 6379
  - Image: `redis:8.0.3-bookworm`
  - Password: `password`
  - Persistence: enabled (AOF)
  - Volume: `redis_data`

- **RedisInsight** (`ri`): Redis management interface
  - Port: 5540
  - Image: `redis/redisinsight:2.70`
  - Volume: `redisinsight`

## Quick Commands

### Start the stack
```bash
docker compose up -d
```

### Stop the stack
```bash
docker compose down
```

### View logs
```bash
docker compose logs -f [service_name]
```

### Download base Ollama models
```bash
./download-ollama-models.sh
```

### Update Ollama models
```bash
./update-ollama-models.sh
```

## Service Access

| Service | URL | Credentials |
|---------|-----|-------------|
| Open WebUI | http://localhost:3000 | - |
| pgAdmin | http://localhost:80 | postgres@asdf.de / password |
| RedisInsight | http://localhost:5540 | - |

## Database Connections

### PostgreSQL (Main)
- **Host**: localhost
- **Port**: 5432
- **Database**: vision
- **Username**: postgres
- **Password**: password

### pgVector (AI/ML)
- **Host**: localhost
- **Port**: 5433
- **Username**: postgres
- **Password**: password

### Redis
- **Host**: localhost
- **Port**: 6379
- **Password**: password

## Volume Management

All data is persisted in Docker volumes:
- `postgres_data`: Main PostgreSQL data
- `pgvector17_data`: pgVector database data
- `redis_data`: Redis data and AOF files
- `ollama`: AI models and configurations
- `open-webui`: Web UI user data and settings
- `pgadmin`: pgAdmin configurations
- `redisinsight`: RedisInsight settings

### Backup volumes
```bash
docker run --rm -v pgvector17_data:/data -v $(pwd):/backup alpine tar czf /backup/pgvector_backup.tar.gz -C /data .
```

### Restore volumes
```bash
docker run --rm -v pgvector17_data:/data -v $(pwd):/backup alpine tar xzf /backup/pgvector_backup.tar.gz -C /data
```

## GPU Support

The Ollama service is configured for AMD ROCm GPU acceleration:
- Requires ROCm drivers installed on host
- GPU devices are automatically mounted
- Models will use GPU acceleration when available

## Model Management

Use the included scripts to manage Ollama models:

### Download base models
```bash
./download-ollama-models.sh
```

### Update existing models
```bash
./update-ollama-models.sh
```

The download script will:
1. Check if Ollama container is running
2. Show current models and models to download
3. Prompt for confirmation
4. Download predefined base models

The update script will:
1. List current models
2. Prompt for confirmation
3. Update all installed models
4. Show final status

## Troubleshooting

### Check service status
```bash
docker compose ps
```

### View service logs
```bash
docker compose logs [service_name]
```

### Restart a service
```bash
docker compose restart [service_name]
```

### Reset everything
```bash
docker compose down -v  # Warning: removes all data
docker compose up -d
```
