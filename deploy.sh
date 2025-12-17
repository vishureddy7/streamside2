#!/bin/bash

# Streamside Production Deployment Script
# Run this on your Arch Linux server

set -e

echo "🚀 Streamside Production Deployment"
echo "===================================="

# Check if .env exists
if [ ! -f ".env" ]; then
    echo "❌ .env file not found!"
    echo "   Copy .env.production to .env and fill in your values:"
    echo "   cp .env.production .env"
    exit 1
fi

# Check if domain is configured
if grep -q "yourdomain.com" Caddyfile; then
    echo "❌ Please update Caddyfile with your actual domain!"
    echo "   Replace YOUR_DOMAIN with your domain (e.g., studio.example.com)"
    exit 1
fi

# Install dependencies and build
echo "📦 Installing dependencies..."
pnpm install --frozen-lockfile

echo "🔨 Building application..."
pnpm build

# Generate Prisma client
echo "🗄️ Generating Prisma client..."
cd packages/database && pnpm db:generate && cd ../..

# Build and start containers
echo "🐳 Starting Docker containers..."
docker compose -f docker-compose.prod.yml build
docker compose -f docker-compose.prod.yml up -d

# Wait for postgres
echo "⏳ Waiting for PostgreSQL..."
sleep 10

# Run migrations
echo "🗄️ Running database migrations..."
docker compose -f docker-compose.prod.yml exec web pnpm db:migrate

echo ""
echo "✅ Deployment complete!"
echo ""
echo "Your app should be available at your configured domain."
echo ""
echo "Useful commands:"
echo "  View logs:     docker compose -f docker-compose.prod.yml logs -f"
echo "  Restart:       docker compose -f docker-compose.prod.yml restart"
echo "  Stop:          docker compose -f docker-compose.prod.yml down"
echo "  Update:        git pull && ./deploy.sh"
