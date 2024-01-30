#!/bin/bash
set -e

# Erlang build script
readonly OTP_VERSION="26.2.1"
readonly BUILD_CROSS_TRIPLE="x86_64-linux-gnu"
readonly HOST_CROSS_TRIPLE="${CROSS_TRIPLE}"

download_erlang() {
    local url="https://github.com/erlang/otp/releases/download/OTP-$OTP_VERSION/otp_src_$OTP_VERSION.tar.gz"
    local file="otp_src_$OTP_VERSION.tar.gz"

    if [ ! -f "$file" ]; then
        echo "Downloading Erlang/OTP..."
        wget "$url" -O "$file"
    fi

    if [ ! -d "otp_src_$OTP_VERSION" ]; then
        echo "Extracting Erlang/OTP..."
        tar xzf "$file"
    fi
}

build_erlang() {
    local erlang_dir="otp_src_$OTP_VERSION"
    pushd "$erlang_dir"

    ./configure \
        --without-javac \
        --without-jinterface \
        --without-wx \
        --without-termcap \
        --without-megaco \
        --with-ssl=$(pwd)/../sysroot \
        --disable-dynamic-ssl-lib \
        --host "${HOST_CROSS_TRIPLE}" \
        --build="${BUILD_CROSS_TRIPLE}"
    make -j$(nproc)

    local release_root="$(pwd)/release/otp_armv7l_linux_${OTP_VERSION}"
    make release -j$(nproc) RELEASE_ROOT="$release_root"

    popd
}

package_erlang(){
    tar czf otp_${OTP_VERSION}_linux_any_armv7l_ssl_${OPENSSL_VERSION}.tar.gz ./otp*
}

echo "Building Erlang/OTP $OTP_VERSION"
download_erlang
build_erlang
echo "Erlang/OTP build completed."
