#!/bin/bash

# Code Butler Setup Script
# This script helps set up the Serverpod project

set -e

echo "🚀 Setting up Code Butler project..."

# Check if Dart is installed
if ! command -v dart &> /dev/null; then
    echo "❌ Dart is not installed. Please install Dart SDK first."
    exit 1
fi

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed. Please install Flutter SDK first."
    exit 1
fi

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "⚠️  Docker is not installed. Database setup will be skipped."
    SKIP_DOCKER=true
fi

# Install Serverpod CLI
echo "📦 Installing Serverpod CLI..."
dart pub global activate serverpod_cli

# Install server dependencies
echo "📦 Installing server dependencies..."
cd code_butler_server
dart pub get

# Generate client code
echo "🔧 Generating client code..."
serverpod generate

# Install Flutter dependencies
echo "📦 Installing Flutter dependencies..."
cd ../code_butler_flutter
flutter pub get

# Start Docker if available
if [ "$SKIP_DOCKER" != true ]; then
    echo "🐳 Starting PostgreSQL database..."
    cd ..
    docker compose up -d
    
    echo "⏳ Waiting for database to be ready..."
    sleep 5
    
    # Apply migrations
    echo "🗄️  Applying database migrations..."
    cd code_butler_server
    serverpod create-migration
    serverpod apply-migrations
else
    echo "⚠️  Skipping database setup. Please install Docker and run:"
    echo "   docker compose up -d"
    echo "   cd code_butler_server && serverpod create-migration && serverpod apply-migrations"
fi

echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Configure API keys in config/github_oauth.yaml and config/gemini_api.yaml"
echo "2. Start the server: cd code_butler_server && dart run bin/server.dart"
echo "3. Run the Flutter app: cd code_butler_flutter && flutter run"

