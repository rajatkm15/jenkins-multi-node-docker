#!/bin/bash

setup-sshd 

chown -R jenkins:jenkins /home/jenkins/.ssh

exec su jenkins "$@"
