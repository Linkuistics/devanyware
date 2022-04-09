da/install-nodejs-prereqs () {
    set -euxo pipefail

    [[ -a ~/.config/zsh/nodejs.zshenv ]] && return
    asdf plugin add nodejs
    touch ~/.config/zsh/nodejs.zshenv
}

da/install-nodejs-version () {
    set -euxo pipefail

    VERSION=$1

    da/install-nodejs-prereqs

    asdf install nodejs $VERSION
    asdf local nodejs $VERSION
    hash -r
}

da/install-yarn-prereqs () {
    set -euxo pipefail

    [[ -a ~/.config/zsh/yarn.zshenv ]] && return
    asdf plugin add yarn
    touch ~/.config/zsh/yarn.zshenv
}

da/install-yarn-version () {
    set -euxo pipefail

    VERSION=$1

    da/install-yarn-prereqs

    asdf install yarn $VERSION
    asdf local yarn $VERSION
    hash -r
}
