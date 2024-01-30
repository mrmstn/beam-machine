#!/bin/bash
set -e

readonly OPENSSL_VERSION="3.2.1"
readonly OTP_VERSION="26.2.1"

./dockcross-linux-armv7l-musl ./build-openssl.sh
./dockcross-linux-x64 ./build-erlang-bootstrap.sh
./dockcross-linux-armv7l-musl ./build-erlang.sh

./package.sh