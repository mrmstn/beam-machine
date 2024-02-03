#!/bin/bash
set -e

readonly OPENSSL_VERSION="3.2.1"
readonly OTP_VERSION="26.2.1"

./dockcross-linux-armv7l-musl ./build-openssl.sh
./dockcross-linux-x64 ./build-erlang-bootstrap.sh
./dockcross-linux-armv7l-musl ./build-erlang.sh

# TODO: Check patching of musl
# /usr/xcc/armv7l-linux-musleabihf-cross/armv7l-linux-musleabihf/lib/ld-musl-armhf.so.1
# TODO: Extract and ship musl?
# ./dockcross-linux-armv7l-musl cp /usr/xcc/armv7l-linux-musleabihf-cross/armv7l-linux-musleabihf/lib/ld-musl-armhf.so.1 ld-musl-armhf.so.1
./dockcross-linux-armv7l-musl cp /usr/xcc/armv7l-linux-musleabihf-cross/armv7l-linux-musleabihf/lib/libc.so ld-musl-armhf.so.1

./package.sh