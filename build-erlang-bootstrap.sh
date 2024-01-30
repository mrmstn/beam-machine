#!/bin/bash
set -e

# Erlang bootstrap build script
readonly OTP_VERSION="26.2.1"
readonly BUILD_CROSS_TRIPLE="${CROSS_TRIPLE}"
#readonly HOST_CROSS_TRIPLE="armv7l-linux-musleabihf"

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

build_erlang_bootstrap() {
    local erlang_dir="otp_src_$OTP_VERSION"
    export ERL_TOP="$(realpath ${erlang_dir})"
    pushd "$erlang_dir"

    ./configure \
        --enable-bootstrap-only \
        --build "${BUILD_CROSS_TRIPLE}"

    make -j$(nproc)

    popd
}

echo "Building Erlang/OTP bootstrap system $OTP_VERSION (${CROSS_TRIPLE})"
download_erlang
build_erlang_bootstrap
echo "Erlang/OTP bootstrap build completed."
