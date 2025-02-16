# **Jenkins Multi-Node Setup with Docker** 🚀

## **📌 Overview**

This project demonstrates how to set up a **Jenkins multi-node environment** using **Docker containers** inside a **Linux VM** running on **VirtualBox**. The setup includes:

- **Jenkins Master** running in a Docker container
- **Jenkins Agent Nodes** in separate Docker containers
- **Docker-in-Docker (DinD)** setup to allow agents to build container images
- **Accessing Jenkins from the host machine**
- **Running CI/CD pipelines inside agent containers**

---

## **📖 Architecture Diagram**

&#x20;*(Replace with your actual diagram)*

---

## **🛠 Prerequisites**

### **For Windows & macOS Users**

1. Install [VirtualBox](https://www.virtualbox.org/) and [Vagrant](https://www.vagrantup.com/) (optional for automation).
2. Follow the official instructions to **set up a Linux VM**:
   - [VirtualBox Setup Guide](https://www.virtualbox.org/manual/UserManual.html)
   - [Creating a Linux VM](https://ubuntu.com/tutorials/install-ubuntu-desktop#1-overview) *(Ubuntu example, but other distributions work too)*
3. Allocate at least **2 CPUs, 4GB RAM**, and **20GB disk space**.

### **For Linux Users**

If you are using a Linux machine, you can skip directly to the **Docker Installation** step.

---

## **⚙️ Setting Up the Environment**

### **1️⃣ Step 1: Install Docker on the Linux VM**

Run the following commands inside your Linux VM:

```sh
sudo apt update && sudo apt upgrade -y
sudo apt install -y docker.io docker-compose
sudo usermod -aG docker $USER
```

**Restart your VM** to apply group changes.

---

### **2️⃣ Step 2: Clone this Repository**

```sh
git clone https://github.com/yourusername/jenkins-multi-node-docker.git
cd jenkins-multi-node-docker
```

---

### **3️⃣ Step 3: Start Jenkins Master and Agent Nodes**

Run the following command to launch Jenkins and agent nodes using Docker Compose:

```sh
docker-compose up -d
```

To check running containers:

```sh
docker ps
```

---

### **4️⃣ Step 4: Access Jenkins**

- Open **http\://****:8080** in your browser
- Retrieve the **admin password** using:
  ```sh
  docker exec -it jenkins-master cat /var/jenkins_home/secrets/initialAdminPassword
  ```
- Complete the Jenkins setup

---

### **5️⃣ Step 5: Configure Agent Nodes in Jenkins**

- Go to **Manage Jenkins → Nodes & Clouds → New Node**
- Register agent nodes using SSH or the **JNLP method**
- Verify connectivity

---

## **🚀 Running CI/CD Pipelines**

Jenkins agents will be able to:
✅ Run build jobs
✅ Build Docker images inside containers
✅ Push images to Docker Hub

Example **Jenkinsfile**:

```groovy
pipeline {
    agent { label 'docker-agent' }
    stages {
        stage('Build Image') {
            steps {
                sh 'docker build -t myapp:latest .'
            }
        }
        stage('Push to DockerHub') {
            steps {
                withDockerRegistry([credentialsId: 'docker-hub-creds']) {
                    sh 'docker push myapp:latest'
                }
            }
        }
    }
}
```

---

## **📸 Demo & Screenshots**

📷 **[Add screenshots or GIFs of Jenkins UI, Agent Configuration, Running Jobs]**

---

## **📂 Repository Structure**

```
📂 jenkins-multi-node-docker  
 ├── 📂 setup-scripts/       # Shell scripts for setup automation  
 ├── 📂 docker/              # Dockerfiles for Jenkins Master & Agents  
 ├── 📂 docs/                # Architecture diagrams & documentation  
 ├── 📂 pipeline-examples/   # Sample Jenkins pipelines  
 ├── 📄 README.md            # This file  
 ├── 📄 docker-compose.yml   # Docker Compose file for easy deployment  
 ├── 📄 .gitignore  
```

---

## **📜 Useful Commands**

Restart all services:

```sh
docker-compose restart
```

Stop all services:

```sh
docker-compose down
```

Check logs:

```sh
docker logs jenkins-master -f
```

---

## **📢 Contributing**

Feel free to open issues or PRs if you find improvements!

---

## **📜 License**

MIT License

