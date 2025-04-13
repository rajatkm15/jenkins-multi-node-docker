#!/bin/bash

#This Script will generate a custom docker-compose file
#Using Docker Compose you can deploy jenkins with multi node


#Creating essential Directories. By Defualt home directory is selected, you can chnange it any custom directory just replace $HOME variable.


DIR="/home/$USER/jenkins-multi-node-docker"


#mkdir -p "$DIR/docker"
mkdir -p "$DIR/jenkins_master"
mkdir -p "$DIR/jenkins_master/.ssh"


#Setting Variables

COMPOSE_FILE="$DIR/docker-compose.yml"
KEY_PATH="$DIR/jenkins_master/.ssh/id_rsa"

touch "$COMPOSE_FILE"
echo "services:" > $COMPOSE_FILE

cat <<EOF >> $COMPOSE_FILE
  jenkins_master:
     image: jenkins/jenkins
     user: "jenkins"
     ports:
     - 8080:8080
     - 50000:50000
     volumes:
     - "$DIR/jenkins_master:/var/jenkins_home"
     - /var/run/docker.sock:/var/run/docker.sock
     networks:
     - jenkins

EOF

#SSH Key Generation

ssh-keygen -t rsa -b 4096 -f "$KEY_PATH" -N ""

chmod 600 "$KEY_PATH"
chmod 600 "$KEY_PATH.pub"
chown -R 1000:1000 "$DIR/jenkins_master/.ssh"  #Enter the UID and GID same as user used in jenkins. By default jenkins is used and it has 1000 as UID and GID"

read -p "Enter the number of nodes: " node_num

for i in $(seq 1 $node_num)
do
	mkdir -p "$DIR/jenkins_agent$i"
	echo "JENKINS_AGENT_SSH_PUBKEY=$(cat $KEY_PATH.pub)" > "$DIR/.env"

	cat<<EOF>> $COMPOSE_FILE
  jenkins_agent$i:
    image: jenkins/ssh-agent
    ports:
    - 50000
    volumes:
    - "$DIR/jenkins_agent$i:/home/jenkins"
    networks:
    - jenkins
    env_file:
    - .env	

EOF

chown -R 1000:1000 "$DIR/jenkins_agent$i" 

done

echo "networks:" >> $COMPOSE_FILE
echo -e "   jenkins:" >> $COMPOSE_FILE
