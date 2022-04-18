#####################################################
# base image
#####################################################

FROM ubuntu:21.04

ENV GLOBAL_CHECK_DATE=2022-03-18

RUN set -eux ; \
    apt-get update ; \
    DEBIAN_FRONTEND='noninteractive' apt-get install -y --no-install-recommends -o APT::Immediate-Configure=false apt-utils locales

RUN locale-gen "en_AU.UTF-8"
ENV LC_ALL=en_AU.UTF-8

RUN set -eux ; \
    echo 'root:root' | chpasswd ; \
    ln -fs /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime ; \
    apt-get update && DEBIAN_FRONTEND='noninteractive' apt-get install -y tzdata sudo ; \
    echo "Set disable_coredump false" >> /etc/sudo.conf

RUN set -eux ; \
    useradd --create-home --user-group --groups sudo dev ; \
    echo 'dev:dev' | chpasswd ; \
    echo "dev ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/dev ; \
    chmod 0440 /etc/sudoers.d/dev


#####################################################
# Basic tools, git, zsh, docker, vim
#####################################################

COPY usr /usr
COPY --chown=dev:dev home/dev /home/dev

RUN yes | unminimize

RUN set -eux ; \
    apt-get update ; \
    DEBIAN_FRONTEND='noninteractive' apt-get install -y --no-install-recommends -o APT::Immediate-Configure=false zsh ; \
    echo 'export path=(/usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin)' >> /etc/zsh/zshenv ; \
    usermod -s /usr/bin/zsh root ; \
    usermod -s /usr/bin/zsh dev

SHELL ["/usr/bin/zsh", "-c"]
CMD ["/usr/bin/zsh"]

RUN set -euxo pipefail ; \
    apt-get update ; \
    DEBIAN_FRONTEND='noninteractive' apt-get install -y --no-install-recommends -o APT::Immediate-Configure=false \
       iproute2 procps lsb-release \
       gnupg2 apt-transport-https ca-certificates \
       openssh-server \
       psmisc htop curl gawk file wget less patch jq sed xz-utils socat unzip vim gettext-base ; \
    mkdir /var/run/sshd ; \
    echo AddressFamily inet >> /etc/ssh/sshd_config

RUN set -euxo pipefail ; \
    apt-get update ; \
    DEBIAN_FRONTEND='noninteractive' apt-get install -y --no-install-recommends -o APT::Immediate-Configure=false git git-lfs git-extras git-flow ; \
    git config --global http.sslVerify false ; \
    git config --global pull.rebase true ; \
    git lfs install

# https://download.docker.com/linux/static/stable/
ENV DOCKER_VERSION=20.10.9
RUN set -euxo pipefail ; \
    curl --location --silent https://download.docker.com/linux/static/stable/$(arch)/docker-${DOCKER_VERSION}.tgz \
       | tar zx --strip-components=1 --directory=/usr/bin docker/docker --no-overwrite-dir

# https://github.com/docker/compose/releases
RUN set -euxo pipefail ; \
    curl --location --silent https://github.com/docker/compose/releases/download/v2.3.4/docker-compose-linux-$(arch) \
        > /usr/local/bin/docker-compose ; \
    chmod +x /usr/local/bin/docker-compose


#####################################################
# Base for dev user
#####################################################

USER dev

RUN mkdir /home/dev/work
WORKDIR /home/dev/work

ENV HERMIT_VERSION=v0.18.3
RUN curl -fsSL https://github.com/cashapp/hermit/releases/download/${HERMIT_VERSION}/install.sh | bash

ENV ASDF_VERSION=0.9.0
RUN set -euxo pipefail ; \
    git clone https://github.com/asdf-vm/asdf.git /home/dev/.asdf --branch v${ASDF_VERSION}

# Separate run block to pick up previous block changes to the shell
RUN set -euxo pipefail ; \
    asdf plugin add starship && asdf install starship latest && asdf global starship latest && echo 'eval "$(starship init zsh)"' > ~/.config/zsh/starship.zshrc