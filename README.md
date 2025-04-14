# Jenkins Multi-Node Setup Using Docker Compose

This project sets up a Jenkins server with a multi-node architecture using Docker Compose. It automates the process of creating Jenkins master and agent containers, allowing you to run Jenkins pipeline jobs inside Docker containers. Perfect for DevOps enthusiasts and learners who want to understand Jenkins distributed builds in a containerized environment.

---

## 🚀 Features

- Jenkins master and multiple agents running in Docker containers
- Agents use a lightweight image based on `jenkins/ssh-agent:alpine`
- Docker CLI and OpenJDK 21 installed in agents to support Docker-based pipeline jobs
- Setup fully automated via a shell script (`setup.sh`)
- Dynamic agent count based on user input
- SSH key setup and volume mappings handled automatically

---

## 🧰 Tech Stack

- Shell Scripting
- Docker & Docker Compose
- Jenkins (Master + SSH Agents)
- Dockerfile (for building custom agent image)
- OpenJDK 21
- Alpine Linux (base image)

---

## 🧱 Custom Agent Image

The Jenkins agents use a custom Docker image built from the official `jenkins/ssh-agent:alpine` image. This image is extended to include:

- Docker CLI (to run Docker commands in pipeline jobs)
- OpenJDK 21 (to support Java-based projects)

---

## 🛠️ Prerequisites

Make sure you have the following installed:

- A Linux system or Windows with WSL
- Docker
- Docker Compose
- Git

---

## ⚙️ Setup Instructions

1. **Clone the Repository**

         git clone https://github.com/rajatkm15/jenkins-multi-node-docker.git

            cd jenkins-multi-node-docker
   
Make the Setup Script Executable

      chmod +x setup.sh

Run the Setup Script

         ./setup.sh

This will:
- Ask for number of Jenkins agents
- Generate SSH keys
- Create required directories (jenkins_master, jenkins_agent1, jenkins_agent2, etc.)
- Generate .env and docker-compose.yml

Build the Docker Image

      docker compose build --no-cache

Start the Jenkins Cluster

      docker compose up

Access Jenkins

      http://localhost:8080 
   Agent port: 50000 (used internally for master-agent communication)

🧪 Coming Soon
- A sample Jenkins pipeline demonstrating:
- Running Docker commands inside agent
- Building a simple Java project

📝 Notes
- The directories jenkins_master, jenkins_agent1, jenkins_agent2, etc., are used as host volumes for Jenkins containers.
- You can modify image name, volume paths, or port mappings in the setup.sh as needed.
- Recommended to always build images first before bringing up containers to avoid using cached layers.

📸 Screenshots
Will be added later.

🙋‍♂️ Author
Rajat Kumar
Feel free to connect or raise issues for enhancements.

