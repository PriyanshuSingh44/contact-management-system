FROM jenkins/jenkins:lts

USER root

# Install Docker CLI so Jenkins can run docker build and docker compose
RUN apt-get update && apt-get install -y docker.io && rm -rf /var/lib/apt/lists/*

USER jenkins
