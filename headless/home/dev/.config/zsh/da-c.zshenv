#####################################################
# C
# https://jake-shadle.github.io/xwin/
#####################################################

da/install-c () {
    set -euxo pipefail

    [[ -a ~/.config/zsh/c.zshenv ]] && return

    sudo apt-get update 
    DEBIAN_FRONTEND='noninteractive' sudo apt-get install -y --no-install-recommends -o APT::Immediate-Configure=false pkg-config gpg libssl-dev

    # https://llvm.org/
    KEYRINGS=/usr/local/share/keyrings \
    LLVM_VERSION=13

    sudo mkdir -p $KEYRINGS 
    sudo zsh -c "curl --fail https://apt.llvm.org/llvm-snapshot.gpg.key | gpg --dearmor > $KEYRINGS/llvm.gpg"
    sudo zsh -c "echo 'deb [signed-by=$KEYRINGS/llvm.gpg] http://apt.llvm.org/bullseye/ llvm-toolchain-bullseye-${LLVM_VERSION} main' > /etc/apt/sources.list.d/llvm.list"
    sudo apt-get update 
    DEBIAN_FRONTEND='noninteractive' sudo apt-get install -y clang-${LLVM_VERSION} llvm-${LLVM_VERSION} lld-${LLVM_VERSION} make ninja-build cmake

    # ensure that clang/clang++ are callable directly
    sudo ln -s clang-${LLVM_VERSION} /usr/bin/clang
    sudo ln -s clang /usr/bin/clang++
    sudo ln -s lld-${LLVM_VERSION} /usr/bin/ld.lld 

    # We also need to setup symlinks ourselves for the MSVC shims because they aren't in the debian packages
    sudo ln -s clang-${LLVM_VERSION} /usr/bin/clang-cl
    sudo ln -s llvm-ar-${LLVM_VERSION} /usr/bin/llvm-lib
    sudo ln -s lld-link-${LLVM_VERSION} /usr/bin/lld-link

    # Verify the symlinks are correct
    clang++ -v 
    ld.lld -v 
    llvm-lib -v # Doesn't have an actual -v/--version flag, but it still exits with 0
    clang-cl -v 
    lld-link --version 

    # Use clang instead of gcc when compiling binaries targeting the host (eg proc macros, build files)
    sudo update-alternatives --install /usr/bin/cc cc /usr/bin/clang 100 
    sudo update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++ 100 

    sudo apt-get remove -y --auto-remove

    touch ~/.config/zsh/c.zshenv
}

#####################################################
# MacOS cross-compile support
# https://github.com/tpoechtrager/osxcross
#####################################################

da/install-c-macos() {
    set -euxo pipefail

    [[ -a ~/.config/zsh/c-macos.zshenv ]] && return

    da/install-c

    sudo apt-get update
    DEBIAN_FRONTEND='noninteractive' sudo apt-get install -y --no-install-recommends -o APT::Immediate-Configure=false libmpc-dev libmpfr-dev libz-dev

    export OSXCROSS_SDK_VERSION=10.10
    export OSXCROSS_PREFIX=x86_64-apple-darwin14

    pushd /home/dev

    git clone https://github.com/tpoechtrager/osxcross
    cd osxcross
    wget -nc https://s3.dockerproject.org/darwin/v2/MacOSX${OSXCROSS_SDK_VERSION}.sdk.tar.xz -O tarballs/MacOSX${OSXCROSS_SDK_VERSION}.sdk.tar.xz
    UNATTENDED=yes OSX_VERSION_MIN=10.10 PORTABLE=true ./build.sh

    (
        echo "export OSXCROSS_SDK_VERSION=${OSXCROSS_SDK_VERSION}"
        echo "export OSXCROSS_PREFIX=${OSXCROSS_PREFIX}"
        echo 'export path=(/home/dev/osxcross/target/bin $path)'
    ) > ~/.config/zsh/c-macos.zshenv

    popd
}

da/install-c-windows() {
    set -euxo pipefail

    [[ -a ~/.config/zsh/c-windows.zshenv ]] && return

    da/install-c

    sudo apt update
    DEBIAN_FRONTEND='noninteractive' sudo apt install -y --no-install-recommends g++-mingw-w64-x86-64

    touch ~/.config/zsh/c-windows.zshenv
}