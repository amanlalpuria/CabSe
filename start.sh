#!/bin/bash

# Exit on any error
set -e

echo "🔧 Setting up Git pre-push hook..."

# Copy pre-push script to .git/hooks and make it executable
cp script/pre-push .git/hooks/pre-push
chmod +x .git/hooks/pre-push

echo "✅ Pre-push hook installed."

export DB_USER=cabse_rw_user
export DB_PASSWORD=cabse_rw_user
export DB_NAME=cabse
export DB_HOST=postgres
export DB_PORT=5432


echo "🚀 Starting docker-compose..."
docker-compose up -d

echo "⏳ Waiting for Postgres & Redis to be healthy..."
while ! docker exec postgres_db pg_isready -U cabse_rw_user > /dev/null 2>&1; do
  echo "🔄 Waiting for Postgres..."
  sleep 3
done

echo "✅ Postgres is ready!"

# Uncomment if Redis is used
# while ! docker exec redis-container redis-cli ping | grep -q "PONG"; do
#   echo "🔄 Waiting for Redis..."
#   sleep 3
# done
# echo "✅ Redis is ready!"

echo "⚙️  Building JAR file using Maven Wrapper..."
chmod +x mvnw  # Ensure the wrapper is executable
./mvnw clean package -DskipTests

echo "🐳 Restarting backend service..."
docker-compose up --build -d backend

echo "✅ Everything is up and running!"
