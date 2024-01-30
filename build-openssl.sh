#!/bin/bash
set -e

# OpenSSL build script
readonly OPENSSL_VERSION="3.2.1"

download_openssl() {
    local url="https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz"
    local file="openssl-$OPENSSL_VERSION.tar.gz"

    if [ ! -f "$file" ]; then
        echo "Downloading OpenSSL..."
        wget "$url" -O "$file"
    fi

    if [ ! -d "openssl-$OPENSSL_VERSION" ]; then
        echo "Extracting OpenSSL..."
        tar xzf "$file"
    fi
}

build_openssl() {
    local openssl_dir="openssl-$OPENSSL_VERSION"
    local sysroot_dir="$(pwd)/sysroot"

    mkdir -p "$sysroot_dir"
    pushd "$openssl_dir"

    export LDFLAGS="-L${CROSS_ROOT}/${CROSS_TRIPLE}/lib -latomic"
    export RANLIB="/usr/bin/ranlib"

    ./config linux-generic32 no-asm no-tests no-shared --prefix="$sysroot_dir" --cross-compile-prefix=/
    make -j$(nproc) && make install_sw

    popd
    ln -sf "$sysroot_dir/lib64" "$sysroot_dir/lib"
}

echo "Building OpenSSL $OPENSSL_VERSION"
download_openssl
build_openssl
echo "OpenSSL build completed."
