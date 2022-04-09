da/install-python-prereqs () {
    set -euxo pipefail

    [[ -a ~/.config/zsh/python.zshenv ]] && return

    sudo apt-get update
    DEBIAN_FRONTEND='noninteractive' sudo apt-get install -y --no-install-recommends -o APT::Immediate-Configure=false \
           libssl-dev zlib1g-dev libbz2-dev \
           libreadline-dev libsqlite3-dev libncursesw5-dev \
           xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

    asdf plugin add python

    touch ~/.config/zsh/python.zshenv
}

da/install-python-version () {
    set -euxo pipefail

    VERSION=$1

    da/install-c
    da/install-python-prereqs

    asdf install python $VERSION
    asdf local python $VERSION
    hash -r
    python -m pip install --upgrade pip
}
