#!/bin/bash

# Script to update Ollama models in Docker container
# This script lists current models and updates them

CONTAINER_NAME="ollama"

echo "=== Ollama Model Update Script ==="
echo "Container: $CONTAINER_NAME"
echo ""

# Check if container is running
if ! docker ps --format "{{.Names}}" | grep -q "^${CONTAINER_NAME}$"; then
    echo "Error: Container '$CONTAINER_NAME' is not running."
    echo "Please start your Docker Compose stack first:"
    echo "  docker compose up -d"
    exit 1
fi

echo "✓ Container '$CONTAINER_NAME' is running"
echo ""

# List current models
echo "📋 Current models in Ollama:"
echo "----------------------------------------"
docker exec $CONTAINER_NAME ollama list
echo ""

# Get list of model names (excluding the header)
models=$(docker exec $CONTAINER_NAME ollama list | tail -n +2 | awk '{print $1}' | grep -v "^$")

if [ -z "$models" ]; then
    echo "No models found to update."
    exit 0
fi

echo "🔄 Found the following models to update:"
echo "$models"
echo ""

# Ask for confirmation
read -p "Do you want to update all models? (y/N): " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Update cancelled."
    exit 0
fi

echo ""
echo "🚀 Starting model updates..."
echo "=========================================="

# Update each model
for model in $models; do
    echo ""
    echo "📥 Updating model: $model"
    echo "----------------------------------------"
    docker exec $CONTAINER_NAME ollama pull "$model"
    
    if [ $? -eq 0 ]; then
        echo "✅ Successfully updated: $model"
    else
        echo "❌ Failed to update: $model"
    fi
done

echo ""
echo "=========================================="
echo "🎉 Model update process completed!"
echo ""

# Show final list
echo "📋 Final model list:"
echo "----------------------------------------"
docker exec $CONTAINER_NAME ollama list
