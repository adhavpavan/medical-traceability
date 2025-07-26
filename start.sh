#!/bin/bash

echo "🚀 Starting Medical Traceability Network..."

# Step 1: Start blockchain network
echo "📦 Starting blockchain network..."
cd blockchain/artifacts
docker-compose up -d
if [ $? -ne 0 ]; then
    echo "❌ Failed to start blockchain network"
    exit 1
fi
cd ../..

# Step 2: Start blockchain explorer
echo "🔍 Starting blockchain explorer..."
cd blockchain/Explorer
docker-compose up -d
if [ $? -ne 0 ]; then
    echo "❌ Failed to start blockchain explorer"
    exit 1
fi
cd ../..

# Step 3: Start API server
echo "🌐 Starting API server..."
cd api
nodemon app.js &
API_PID=$!
echo $API_PID > ../api.pid
cd ..

echo "✅ All services started successfully!"
echo "📊 Blockchain Explorer: http://localhost:8080"
echo "🔗 API Server: http://localhost:3000"
echo ""
echo "To stop all services, run: ./stop.sh"