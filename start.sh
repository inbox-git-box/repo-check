#!/bin/bash

# Scrumora - Start all services without Docker (macOS/Linux)
# Usage: bash start.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$SCRIPT_DIR"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Helper functions
log() {
    local color=$1
    local prefix=$2
    local message=$3
    echo -e "${color}${prefix}${NC} ${message}"
}

banner() {
    echo ""
    echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}  Scrumora - Project Management Tool${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
    echo ""
}

check_requirements() {
    log "$CYAN" "🔍" "Checking prerequisites...\n"

    # Check Node.js
    if ! command -v node &> /dev/null; then
        log "$RED" "✗" "Node.js is not installed!"
        echo "Install from: https://nodejs.org"
        exit 1
    fi
    NODE_VERSION=$(node --version)
    log "$GREEN" "✓" "Node.js $NODE_VERSION detected"

    # Check npm
    if ! command -v npm &> /dev/null; then
        log "$RED" "✗" "npm is not installed!"
        exit 1
    fi
    NPM_VERSION=$(npm --version)
    log "$GREEN" "✓" "npm $NPM_VERSION detected"

    # Check .env file
    if [ ! -f "$ROOT_DIR/.env" ]; then
        log "$YELLOW" "⚠" ".env file not found"
        log "$YELLOW" "⚠" "Using defaults from docker-compose.yml"
    else
        log "$GREEN" "✓" ".env file found"
    fi

    # Check MongoDB
    if command -v mongosh &> /dev/null || command -v mongo &> /dev/null; then
        log "$GREEN" "✓" "MongoDB CLI tools found"
    else
        log "$YELLOW" "⚠" "MongoDB CLI tools not found (optional)"
    fi

    log "$YELLOW" "⚠" "MongoDB must be running on localhost:27017"
    log "$YELLOW" "⚠" "Start MongoDB with: mongod"
    echo ""
}

install_dependencies() {
    log "$BLUE" "📦" "Installing dependencies...\n"

    if [ ! -d "$ROOT_DIR/node_modules" ]; then
        cd "$ROOT_DIR"
        npm install
    fi

    if [ ! -d "$ROOT_DIR/scrumora-api/node_modules" ]; then
        cd "$ROOT_DIR/scrumora-api"
        npm install
    fi

    if [ ! -d "$ROOT_DIR/scrumora-fe/node_modules" ]; then
        cd "$ROOT_DIR/scrumora-fe"
        npm install
    fi

    log "$GREEN" "✓" "Dependencies installed\n"
}

start_services() {
    log "$CYAN" "🚀" "Starting Scrumora services...\n"

    # Start Backend
    log "$YELLOW" "○" "Starting Backend API..."
    cd "$ROOT_DIR/scrumora-api"
    npm run dev &
    BACKEND_PID=$!

    # Start Frontend
    log "$BLUE" "○" "Starting Frontend..."
    cd "$ROOT_DIR/scrumora-fe"
    npm run dev &
    FRONTEND_PID=$!

    echo ""
    log "$GREEN" "✓" "All services started!"
    echo ""
    log "$CYAN" "📍" "Frontend:  http://localhost:3000"
    log "$CYAN" "📍" "Backend:   http://localhost:5001"
    log "$CYAN" "📍" "MongoDB:   localhost:27017"
    echo ""
    log "$CYAN" "💡" "Tip: Press Ctrl+C to stop all services"
    echo ""

    # Cleanup function
    cleanup() {
        log "$YELLOW" "⏹" "Shutting down services..."
        kill $BACKEND_PID 2>/dev/null || true
        kill $FRONTEND_PID 2>/dev/null || true
        exit 0
    }

    trap cleanup SIGINT SIGTERM

    # Wait for all background processes
    wait
}

# Main execution
banner
check_requirements
install_dependencies
start_services
