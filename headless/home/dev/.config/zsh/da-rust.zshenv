da/install-rust () {
    set -euxo pipefail

    [[ -a ~/.config/zsh/rust.zshenv ]] && return

    da/install-c

    # https://rust-lang.github.io/rustup-components-history/index.html

    export RUSTUP_HOME=/home/dev/local/rustup
    export CARGO_HOME=/home/dev/local/cargo
    export path=($CARGO_HOME/bin $path)

    curl https://sh.rustup.rs -sSf | sh -s -- -y
    rustup target add aarch64-unknown-linux-gnu
    rustup target add x86_64-unknown-linux-gnu
    rustup component add rust-analysis rust-src rustfmt clippy

    (
        echo 'export RUSTUP_HOME=/home/dev/local/rustup'
        echo 'export CARGO_HOME=/home/dev/local/cargo'
        echo 'export path=($CARGO_HOME/bin $path)'
    ) > ~/.config/zsh/rust.zshenv
}

da/install-rust-macos () {
    set -euxo pipefail

    [[ -a ~/.config/zsh/rust-macos.zshenv ]] && return

    da/install-c-macos
    da/install-rust

    rustup target add aarch64-apple-darwin
    rustup target add x86_64-apple-darwin

    (
        echo 'export CARGO_TARGET_AARCH64_APPLE_DARWIN_AR=${AARCH64_OSXCROSS_PREFIX}-ar'
        echo 'export CARGO_TARGET_AARCH64_APPLE_DARWIN_LINKER=${AARCH64_OSXCROSS_PREFIX}-clang'
        echo 'export CARGO_TARGET_X86_64_APPLE_DARWIN_AR=${X86_64_OSXCROSS_PREFIX}-ar'
        echo 'export CARGO_TARGET_X86_64_APPLE_DARWIN_LINKER=${X86_64_OSXCROSS_PREFIX}-clang'
    ) > ~/.config/zsh/rust-macos.zshenv

    source ~/.config/zsh/rust-macos.zshenv
}

da/install-rust-windows () {
    set -euxo pipefail

    [[ -a ~/.config/zsh/rust-windows.zshenv ]] && return

    da/install-rust

    rustup target add x86_64-pc-windows-msvc

    # TODO: This should happen in da/install-c-windows
    cargo install xwin
    xwin --accept-license 1 splat --output /home/dev/xwin
    rm -rf .xwin-cache /usr/local/cargo/bin/xwin

    (
        echo 'export CC_x86_64_pc_windows_msvc=clang-cl'
        echo 'export CXX_x86_64_pc_windows_msvc=clang-cl'
        echo 'export AR_x86_64_pc_windows_msvc=llvm-lib'
        echo 'export CFLAGS_x86_64_pc_windows_msvc="-Wno-unused-command-line-argument -fuse-ld=lld-link /imsvc/home/dev/xwin/crt/include /imsvc/home/dev/xwin/sdk/include/ucrt /imsvc/home/dev/xwin/sdk/include/um /imsvc/home/dev/xwin/sdk/include/shared"'
        echo 'export CXXFLAGS_x86_64_pc_windows_msvc="-Wno-unused-command-line-argument -fuse-ld=lld-link /imsvc/home/dev/xwin/crt/include /imsvc/home/dev/xwin/sdk/include/ucrt /imsvc/home/dev/xwin/sdk/include/um /imsvc/home/dev/xwin/sdk/include/shared"'
        # Note that we only disable unused-command-line-argument here since clang-cl
        # doesn't implement all of the options supported by cl, but the ones it doesn't
        # are _generally_ not interesting.
        echo 'export CARGO_TARGET_X86_64_PC_WINDOWS_MSVC_LINKER=lld-link'
        echo 'export CARGO_TARGET_X86_64_PC_WINDOWS_MSVC_RUSTFLAGS="-Lnative=/home/dev/xwin/crt/lib/x86_64 -Lnative=/home/dev/xwin/sdk/lib/um/x86_64 -Lnative=/home/dev/xwin/sdk/lib/ucrt/x86_64"'
    ) > ~/.config/zsh/rust-windows.zshenv

    source ~/.config/zsh/rust-windows.zshenv
}

da/install-wasm-prereqs() {
    set -euxo pipefail

    [[ -a ~/.config/zsh/wasm.zshenv ]] && return

    sudo apt-get update
    DEBIAN_FRONTEND='noninteractive' sudo apt-get install -y --no-install-recommends -o APT::Immediate-Configure=false binaryen wabt
    sudo ln -s /usr/bin/wasm-ld-10 /usr/bin/wasm-ld
    
    touch ~/.config/zsh/rust-wasm.zshenv
}

da/install-rust-wasm() {
    set -euxo pipefail

    [[ -a ~/.config/zsh/rust-wasm.zshenv ]] && return

    da/install-rust
    da/install-wasm-prereqs

    rustup target add wasm32-unknown-unknown
    cargo install wasm-bindgen-cli

    touch ~/.config/zsh/rust-wasm.zshenv
}

da/install-wasisdk-version() {
    set -euxo pipefail

    VERSION=$1

    asdf plugin add wasi-sdk
    asdf install wasi-sdk $VERSION
    asdf local wasi-sdk $VERSION
}
