ARG VERSION_TAG
FROM linkuistics/devanyware-headless:$VERSION_TAG

COPY usr /usr
COPY --chown=dev:dev home/dev /home/dev

USER root
RUN   set -euxo pipefail \
    ; apt-get update \
    ; DEBIAN_FRONTEND='noninteractive' apt-get install -y --no-install-recommends -o APT::Immediate-Configure=false \
    xorg tigervnc-standalone-server tigervnc-common xserver-xephyr openbox polybar \
    xdotool xsel xclip compton xcape \
    nitrogen \
    lxpanel \
    fonts-ubuntu fonts-roboto \
    rofi lxterminal \
    ; rm /etc/fonts/conf.d/10-hinting-slight.conf \
    ; ln -s /etc/fonts/conf.avail/10-hinting-full.conf /etc/fonts/conf.d/ \
    ; ln -s /etc/fonts/conf.avail/10-sub-pixel-rgb.conf /etc/fonts/conf.d/ \
    ; fc-cache -f \
    ; update-alternatives --install /usr/share/icons/default/index.theme x-cursor-theme /usr/share/icons/OSX-ElCap/cursor.theme 100
USER dev
