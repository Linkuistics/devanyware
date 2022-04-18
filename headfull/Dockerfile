ARG VERSION_TAG

#####################################################
# polybar staged image
#####################################################

FROM ubuntu:21.04 AS polybar

ENV LC_ALL=C.UTF-8

RUN set -eux ; \
    echo 'root:root' | chpasswd ; \
    ln -fs /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime ; \
    apt-get update ; \
    DEBIAN_FRONTEND='noninteractive' apt-get install -y --no-install-recommends -o APT::Immediate-Configure=false \
       gnupg2 apt-transport-https ca-certificates \
       sudo zsh \
       curl wget jq sed gpp gawk xz-utils neovim unzip git patch ; \
    git config --global http.sslVerify false ; \
    usermod -s /usr/bin/zsh root

WORKDIR /root

SHELL ["/usr/bin/zsh", "-c"]

COPY polybar /polybar

RUN set -euxo pipefail ; \
    apt-get update ; \
    DEBIAN_FRONTEND='noninteractive' apt-get install -y --no-install-recommends -o APT::Immediate-Configure=false \
       git ninja-build pkg-config cmake llvm clang $(cat /polybar/dependencies) ; \
    git clone -q --recursive https://github.com/polybar/polybar -b 3.4.2 ; \
    mkdir build ; \
    cd build ; \
    cmake -G Ninja -DCMAKE_INSTALL_PREFIX=/polybar -DCMAKE_CXX_FLAGS=-Wno-defaulted-function-deleted ../polybar ; \
    ninja install


#####################################################
# base image
#####################################################

FROM linkuistics/devanyware-headless:$VERSION_TAG

COPY usr /usr
COPY --chown=dev:dev home/dev /home/dev

COPY --from=polybar /polybar /polybar

USER root
RUN set -euxo pipefail ; \
    apt-get update ; \
    DEBIAN_FRONTEND='noninteractive' apt-get install -y --no-install-recommends -o APT::Immediate-Configure=false \
       xorg tigervnc-standalone-server tigervnc-common xserver-xephyr openbox \
       xdotool xsel xclip compton xcape \
       nitrogen \
       lxpanel \
       fonts-ubuntu fonts-roboto \
       firefox rofi imagemagick lxterminal \
       $(cat /polybar/dependencies) ; \
    cat /polybar/zshenv >> /etc/zsh/zshenv ; \
    rm /etc/fonts/conf.d/10-hinting-slight.conf ; \
    ln -s /etc/fonts/conf.avail/10-hinting-full.conf /etc/fonts/conf.d/ ; \
    ln -s /etc/fonts/conf.avail/10-sub-pixel-rgb.conf /etc/fonts/conf.d/ ; \
    fc-cache -f ; \
    update-alternatives --install /usr/share/icons/default/index.theme x-cursor-theme /usr/share/icons/OSX-ElCap/cursor.theme 100
USER dev
