FROM ubuntu:18.04

LABEL "maintainer"="liksi <ops@liksi.fr>"
# Setup build arguments with default versions
ARG AZURE_CLI_VERSION=2.4.0
ARG TERRAFORM_VERSION=0.12.23

RUN apt-get update \
    && apt-get install -y curl git unzip \
    && rm -rf /var/lib/apt/lists/*

# Setup build arguments with default versions
RUN curl -LO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && chmod +x ./terraform \
    && mv ./terraform /usr/local/bin/terraform \
    && rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

RUN apt-get update -qq \
    && \
    apt-get install -qqy --no-install-recommends\
      apt-transport-https \
      build-essential \
      curl \
      ca-certificates \
      lsb-release \
      gnupg \
    && \
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ bionic main" | tee /etc/apt/sources.list.d/azure-cli.list \
    && \
    curl -sL https://packages.microsoft.com/keys/microsoft.asc | \
        gpg --dearmor | \
        tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null \
    && \
    apt-get update -qq &&  apt-get install azure-cli=${AZURE_CLI_VERSION}-1~bionic \
    && \
    rm -rf /var/lib/apt/lists/*

CMD ["/bin/bash"]
