FROM ubuntu:22.04

RUN set -eux ; \
    apt-get update ; \
    DEBIAN_FRONTEND='noninteractive' apt-get install -y --no-install-recommends -o APT::Immediate-Configure=false \
    apt-utils locales

RUN locale-gen "en_AU.UTF-8"
ENV LC_ALL=en_AU.UTF-8

RUN set -eux ; \
    echo 'root:root' | chpasswd ; \
    ln -fs /usr/share/zoneinfo/Australia/Melbourne /etc/localtime ; \
    apt-get update ; \
    DEBIAN_FRONTEND='noninteractive' apt-get install -y \
    tzdata sudo \
    lsb-release \
    gnupg2 apt-transport-https ca-certificates \
    iproute2 procps psmisc htop ; \
    echo "Set disable_coredump false" >> /etc/sudo.conf

COPY usr /usr


#####################################################
# Create dev user
#####################################################

RUN set -eux ; \
    useradd --create-home --user-group --groups sudo dev ; \
    echo 'dev:dev' | chpasswd ; \
    echo "dev ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/dev ; \
    chmod 0440 /etc/sudoers.d/dev

COPY --chown=dev:dev home/dev /home/dev


#####################################################
# ZSH
#####################################################

RUN set -eux ; \
    apt-get update ; \
    DEBIAN_FRONTEND='noninteractive' apt-get install -y --no-install-recommends -o APT::Immediate-Configure=false zsh ; \
    echo 'export path=(/usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin)' >> /etc/zsh/zshenv ; \
    usermod -s /usr/bin/zsh root ; \
    usermod -s /usr/bin/zsh dev

SHELL ["/usr/bin/zsh", "-c"]
CMD ["/usr/bin/zsh"]


#####################################################
# File manipulation
#####################################################

RUN set -euxo pipefail ; \
    apt-get update ; \
    DEBIAN_FRONTEND='noninteractive' apt-get install -y --no-install-recommends -o APT::Immediate-Configure=false \
    file less patch \
    curl wget \
    gawk sed \
    jq \
    xz-utils unzip \
    vim


#####################################################
# Git
#####################################################

RUN set -euxo pipefail ; \
    apt-get update ; \
    DEBIAN_FRONTEND='noninteractive' apt-get install -y --no-install-recommends -o APT::Immediate-Configure=false \
    git git-lfs git-extras git-flow ; \
    git config --global http.sslVerify false ; \
    git config --global pull.rebase true ; \
    git lfs install


#####################################################
# Docker client - https://download.docker.com/linux/static/stable/
#####################################################

ENV DOCKER_CLIENT_VERSION=20.10.9
RUN set -euxo pipefail ; \
    curl --location --silent https://download.docker.com/linux/static/stable/$(arch)/docker-${DOCKER_CLIENT_VERSION}.tgz \
    | tar zx --strip-components=1 --directory=/usr/bin docker/docker --no-overwrite-dir


#####################################################
# Docker compose - https://github.com/docker/compose/releases
#####################################################

ENV DOCKER_COMPOSE_VERSION=2.11.1
RUN set -euxo pipefail ; \
    curl --location --silent https://github.com/docker/compose/releases/download/v${DOCKER_COMPOSE_VERSION}/docker-compose-linux-$(arch) \
    > /usr/local/bin/docker-compose ; \
    chmod +x /usr/local/bin/docker-compose


#####################################################
# Default user and work dir
#####################################################

USER dev
RUN mkdir /home/dev/work
WORKDIR /home/dev/work


#####################################################
# Hermit package manager - https://cashapp.github.io/hermit/
#####################################################

# https://github.com/cashapp/hermit/releases/
ENV HERMIT_VERSION=0.28.0
RUN curl -fsSL https://github.com/cashapp/hermit/releases/download/v${HERMIT_VERSION}/install.sh | bash


#####################################################
# vscode devcontainer support
#####################################################

RUN mkdir -p /home/dev/.vscode-server/extensions
