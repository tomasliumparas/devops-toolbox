FROM centos:8

MAINTAINER Tomas Liumparas <tomas.liumparas@gmail.com>
LABEL maintainer="tomas.liumparas@gmail.com"

# https://www.terraform.io/downloads.html
ARG TERRAFORM_VERSION="0.13.2"
# https://storage.googleapis.com/kubernetes-release/release/stable.txt
ARG KUBECTL_VERSION="1.19.1"
# https://pypi.org/project/awscli/
ARG AWS_CLI_VERSION="1.18.137"
# https://pypi.org/project/azure-cli/
ARG AZ_CLI_VERSION="2.11.1"
# https://github.com/docker/compose/releases/
ARG DOCKER_COMPOSE_VERSION="1.27.2"
# https://github.com/kubernetes/kompose/releases
ARG KOMPOSE_VERSION="1.21.0"


ENV HOME=/opt/app/root

# Install OS packages
RUN yum install -y \
    wget \
    unzip \
    python38 \
    tree \
    jq \

    # envsubst
    gettext

# Download binaries
RUN mkdir dl && \
    cd dl && \

    ## Terraform
    curl -so terraform.zip \
      https://releases.hashicorp.com/terraform/$TERRAFORM_VERSION/terraform\_$TERRAFORM_VERSION\_linux_amd64.zip && \
    unzip terraform.zip -d /usr/local/bin && \
    terraform --version && \

    ## kubectl
    curl -so /usr/local/bin/kubectl \
      https://storage.googleapis.com/kubernetes-release/release/v$KUBECTL_VERSION/bin/linux/amd64/kubectl && \
    chmod +x /usr/local/bin/kubectl && \
    # kubectl version && \

    ## docker-compose
    curl -Lso /usr/local/bin/docker-compose \
      https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-Linux-x86_64 && \
    chmod +x /usr/local/bin/docker-compose && \
    docker-compose version && \

    ## kompose
    curl -Lso /usr/local/bin/kompose \
      https://github.com/kubernetes/kompose/releases/download/v$KOMPOSE_VERSION/kompose-linux-amd64 && \
    chmod +x /usr/local/bin/kompose && \
    kompose version

# Install pip3 packages
    ## awscli
RUN pip3 install --quiet awscli==$AWS_CLI_VERSION && \
    aws --version && \

    ## azure-cli
    pip3 install --quiet azure-cli==$AZ_CLI_VERSION && \
    az --version
