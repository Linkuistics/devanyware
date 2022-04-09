da/install-asdf-tool-versions () {
    set -euxo pipefail

    # Need to do these manually because we do more than just asdf install <p> <v>

    V=$((grep nodejs .tool-versions || true) | cut -d ' ' -f 2)
    [[ ! -z "$V" ]] && da/install-nodejs-version $V

    V=$((grep yarn .tool-versions  || true) | cut -d ' ' -f 2)
    [[ ! -z "$V" ]] && da/install-yarn-version $V

    V=$((grep python .tool-versions || true) | cut -d ' ' -f 2)
    [[ ! -z "$V" ]] && da/install-python-version $V

    V=$((grep erlang .tool-versions || true) | cut -d ' ' -f 2)
    [[ ! -z "$V" ]] && da/install-erlang-version $V

    V=$((grep elixir .tool-versions || true) | cut -d ' ' -f 2)
    [[ ! -z "$V" ]] && da/install-elixir-version $V

    asdf install
}