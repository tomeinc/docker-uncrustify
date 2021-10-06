#!/usr/bin/env bash
set -euo pipefail

msg() {
    echo >&2 -e "${1-}"
}
die() {
    local msg=$1
    local code=${2-1} # default exit status 1
    msg "$msg"
    exit "$code"
}


build-configure-add-unistd() {
    # https://github.com/uncrustify/uncrustify/issues/1747#issuecomment-389116832
    sed -i 's/\/\* Global data \*\//#include <unistd.h>\n\n\/* Global data *\//' src/uncrustify.cpp
    build-configure
}
build-configure() {
    ./configure
    make -j"$(nproc)"
    cp src/uncrustify /usr/local/bin/
}
build-autogen() {
    ./autogen.sh
    build-configure
}
build-cmake-add-stdexcept() {
    sed -i 's/using namespace std;/#include <stdexcept>\n\nusing namespace std;/' src/indent.cpp
    build-cmake
}
build-cmake() {
    echo "cmake stuff"
    pwd
    git tag
    mkdir build && cd build
    cmake ..
    cmake --build .
    make install
}

cd /tmp
git clone --depth 1 --branch "${TAG}" https://github.com/uncrustify/uncrustify.git
cd uncrustify
echo "building $TAG with $BUILD_TYPE"
case "${BUILD_TYPE}" in
    configure-add-unistd)
        build-configure-add-unistd
        ;;
    configure)
        build-configure
        ;;
    autogen)
        build-autogen
        ;;
    cmake)
        build-cmake
        ;;
    cmake-add-stdexcept)
        build-cmake-add-stdexcept
        ;;
    *)
        die "unknown BUILD_TYPE ${BUILD_TYPE}"
        ;;
esac
cd /
rm -rf /tmp/uncrustify
uncrustify --version

