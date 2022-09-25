da/install-python-prereqs () {
    set -euxo pipefail

    [[ -a ~/.config/zsh/python-prereqs.zshenv ]] && return

    sudo apt-get update
    DEBIAN_FRONTEND='noninteractive' sudo apt-get install -y --no-install-recommends -o APT::Immediate-Configure=false \
           libssl-dev zlib1g-dev libbz2-dev \
           libreadline-dev libsqlite3-dev libncursesw5-dev \
           xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

    touch ~/.config/zsh/python-prereqs.zshenv
}