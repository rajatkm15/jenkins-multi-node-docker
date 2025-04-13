#!/bin/bash

# Jenkins Multi-Node Docker Deployment Script
# This script generates a custom docker-compose.yml file for deploying Jenkins with multiple agent nodes
# Usage: Simply run the script and follow the prompts

# Configuration Section
# --------------------------------------------------

# Base directory for Jenkins files (can be changed to any directory)
JENKINS_BASE_DIR="/home/$USER/jenkins-multi-node-docker"

# Docker Compose file and SSH key paths
COMPOSE_FILE="$JENKINS_BASE_DIR/docker-compose.yml"
KEY_PATH="$JENKINS_BASE_DIR/jenkins_master/.ssh/id_rsa"

# Jenkins user UID and GID (default is 1000:1000)
JENKINS_UID=1000
JENKINS_GID=1000

# --------------------------------------------------

# Create necessary directory structure
echo "Setting up directory structure in $JENKINS_BASE_DIR..."

mkdir -p "$JENKINS_BASE_DIR/jenkins_master/.ssh"

# Initialize docker-compose.yml file
echo "Creating docker-compose.yml..."
cat <<EOF > "$COMPOSE_FILE"
version: '3.8'  # Explicit version for better compatibility
services:
  jenkins_master:
    image: jenkins/jenkins:lts  # Using LTS version for stability
    ports:
      - "8080:8080"  # Web UI port
      - "50000:50000"  # Agent communication port
    volumes:
      - "$JENKINS_BASE_DIR/jenkins_master:/var/jenkins_home"
      - "/var/run/docker.sock:/var/run/docker.sock"  # Allows Jenkins to run Docker commands
    networks:
      - jenkins
    restart: unless-stopped  # Auto-restart policy for reliability

EOF

# Generate SSH key pair for agent communication
echo "Generating SSH keys for Jenkins agent communication..."
ssh-keygen -t rsa -b 4096 -f "$KEY_PATH" -N "" -q  # -q for quiet mode
chmod 600 "$KEY_PATH" "$KEY_PATH.pub"
chown -R "${JENKINS_UID}:${JENKINS_GID}" "$JENKINS_BASE_DIR/jenkins_master/.ssh"

# Store public key in environment file for agents
echo "JENKINS_AGENT_SSH_PUBKEY=$(cat $KEY_PATH.pub)" > "$JENKINS_BASE_DIR/.env"

# Get number of agent nodes from user
while true; do
    read -p "Enter the number of agent nodes to create: " node_num
    
    # Validate input is a positive integer
    if [[ "$node_num" =~ ^[0-9]+$ ]] && [ "$node_num" -gt 0 ]; then
        break
    else
        echo "Error: Please enter a valid positive number" >&2
    fi
done

# Create agent services in docker-compose.yml
echo "Configuring $node_num agent nodes..."
for i in $(seq 1 "$node_num"); do
    agent_dir="$JENKINS_BASE_DIR/jenkins_agent$i"
    mkdir -p "$agent_dir"
    
    cat <<EOF >> "$COMPOSE_FILE"
  jenkins_agent${i}:
    build: .
    image: rajatkm93/ssh-agent:v2 #Add your docker hub repo
    ports:
      - "50000"  # Agent communication port
    volumes:
      - "$agent_dir:/home/jenkins" 
      - "/var/run/docker.sock:/var/run/docker.sock"  # Allows Jenkins to run Docker commands
    networks:
      - jenkins
    env_file:
      - .env
    restart: unless-stopped
    deploy:
      resources:
        limits:
          cpus: '0.5'  # CPU limit
          memory: 512M  # Memory limit

EOF

    #chown -R "${JENKINS_UID}:${JENKINS_GID}" "$agent_dir"
done

# Add network configuration
cat <<EOF >> "$COMPOSE_FILE"
networks:
  jenkins:
    driver: bridge
    attachable: true  # Allows containers to attach after creation
EOF

# Completion message
echo -e "\nSetup complete!"
echo "You can now start your Jenkins cluster with:"
echo "cd $JENKINS_BASE_DIR && docker-compose up -d"
echo -e "\nAccess Jenkins at: http://localhost:8080"
echo "SSH private key for agents is stored at: $KEY_PATH"
