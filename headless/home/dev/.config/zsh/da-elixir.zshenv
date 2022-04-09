da/install-erlang-elixir-prereqs () {
    set -euxo pipefail

    [[ -a ~/.config/zsh/elixir.zshenv ]] && return

    sudo apt-get update
    DEBIAN_FRONTEND='noninteractive' sudo apt-get install -y --no-install-recommends -o APT::Immediate-Configure=false autoconf m4 automake libncurses5-dev libssh-dev xsltproc fop libxml2-utils libncurses-dev gcc

	asdf plugin add erlang
	asdf plugin add elixir

    touch ~/.config/zsh/elixir.zshenv
}

da/install-erlang-version() {
    set -euxo pipefail

    VERSION=$1

    da/install-erlang-elixir-prereqs

 	asdf install erlang $VERSION
    asdf local erlang $VERSION
}

da/install-elixir-version() {
    set -euxo pipefail

    VERSION=$1

    da/install-erlang-elixir-prereqs

 	asdf install elixir $VERSION
    asdf local elixir $VERSION
}