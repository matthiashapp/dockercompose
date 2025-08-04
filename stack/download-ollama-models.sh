#!/bin/bash

# Script to download base models from Ollama
# This script downloads a predefined list of models

CONTAINER_NAME="ollama"

# Array of models to download
MODELS=(
    "deepseek-r1:1.5b"
    "deepseek-r1:7b"
    "deepseek-r1:8b"
    "deepseek-r1:14b"
    "gemma3n:e2b"
    "gemma3n:e4b"
    "gemma3:1b"
    "gemma3:4b"
    "gemma3:12b"
    "gemma3:27b"
    "qwen3:0.6b"
    "qwen3:1.7b"
    "qwen3:4b"
    "qwen3:8b"
    "qwen3:14b"
    "qwen2.5vl:3b"
    "qwen2.5vl:7b"
    "llama3.1:8b"
    "llama3.2:1b"
    "llama3.2:3b"
    "nomic-embed-text:v1.5"
    "llava:7b"
    "llava:13b"
    "phi4:14b"
    "phi3:3.8b"
    "phi3:14b"
)

echo "=== Ollama Model Download Script ==="
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

# Show models to be downloaded
echo "📥 Models to download:"
echo "----------------------------------------"
for model in "${MODELS[@]}"; do
    echo "  - $model"
done
echo ""

# Ask for confirmation
read -p "Do you want to download these models? (y/N): " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Download cancelled."
    exit 0
fi

echo ""
echo "🚀 Starting model downloads..."
echo "=========================================="

# Download each model
success_count=0
failed_count=0

for model in "${MODELS[@]}"; do
    echo ""
    echo "📥 Downloading model: $model"
    echo "----------------------------------------"
    
    # Check if model already exists
    if docker exec $CONTAINER_NAME ollama list | grep -q "^$model"; then
        echo "ℹ️  Model '$model' already exists. Pulling latest version..."
    fi
    
    docker exec $CONTAINER_NAME ollama pull "$model"
    
    if [ $? -eq 0 ]; then
        echo "✅ Successfully downloaded: $model"
        ((success_count++))
    else
        echo "❌ Failed to download: $model"
        ((failed_count++))
    fi
done

echo ""
echo "=========================================="
echo "🎉 Model download process completed!"
echo ""
echo "📊 Summary:"
echo "  ✅ Successfully downloaded: $success_count model(s)"
echo "  ❌ Failed downloads: $failed_count model(s)"
echo ""

# Show final list
echo "📋 Final model list:"
echo "----------------------------------------"
docker exec $CONTAINER_NAME ollama list
