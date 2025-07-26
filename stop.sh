#!/bin/bash

echo "🛑 Stopping Medical Traceability Network..."

# Step 1: Stop API server
echo "🌐 Stopping API server..."
if [ -f api.pid ]; then
    API_PID=$(cat api.pid)
    if ps -p $API_PID > /dev/null; then
        kill $API_PID
        echo "✅ API server stopped"
    else
        echo "⚠️  API server was not running"
    fi
    rm api.pid
else
    echo "⚠️  No API PID file found, attempting to kill nodemon processes..."
    pkill -f "nodemon app.js" || echo "No nodemon processes found"
fi

# Step 2: Stop blockchain explorer
echo "🔍 Stopping blockchain explorer..."
cd blockchain/Explorer
docker-compose down
cd ../..

# Step 3: Stop blockchain network
echo "📦 Stopping blockchain network..."
cd blockchain/artifacts
docker-compose down
cd ../..

echo "✅ All services stopped successfully!"