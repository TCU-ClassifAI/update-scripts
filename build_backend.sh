#!/bin/bash

# Define the path to the server script and the PID file
SERVER_SCRIPT="/home/web/classifAI/backend/server.js"
PID_FILE="/home/web/classifAI/backend/server.pid"

# Check if the PID file exists and read the PID from it
if [ -f "$PID_FILE" ]; then
    OLD_PID=$(cat "$PID_FILE")
    if ps -p "$OLD_PID" > /dev/null; then
        echo "Stopping existing Node.js server..."
        kill "$OLD_PID"
    fi
fi

# Change directory to the backend directory
cd /home/web/classifAI/backend/

# Check to see if Mongo is Up, if not fail? 
npm install

# Start the new Node.js server
echo "Starting new Node.js server..."
nohup node "$SERVER_SCRIPT" > /dev/null 2>&1 &

# Save the PID of the new process to the PID file
echo $! > "$PID_FILE"
