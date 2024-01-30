#!/bin/bash
set -e

# Function to extract OpenSSL version from openssl.pc
extract_openssl_version() {
    local openssl_pc="$1"
    if [ ! -f "$openssl_pc" ]; then
        echo "Error: openssl.pc not found at $openssl_pc"
        exit 1
    fi
    grep Version "$openssl_pc" | cut -d ' ' -f 2
}

# Function to extract OTP version from otp_src_*/OTP_VERSION
extract_otp_version() {
    local otp_version_file=$(find . -name "OTP_VERSION" -path "./otp_src_*/OTP_VERSION" -print -quit)
    if [ ! -f "$otp_version_file" ]; then
        echo "Error: OTP_VERSION file not found"
        exit 1
    fi
    cat "$otp_version_file"
}

# Function to find the OTP release directory name
find_otp_release_dir() {
    local otp_version=$1
    local release_dir=$(find "./otp_src_${otp_version}/release" -mindepth 1 -maxdepth 1 -type d -print -quit)
    echo $(basename "$release_dir")
}

# Define the path to openssl.pc
OPENSSL_PC_PATH="sysroot/lib/pkgconfig/openssl.pc"

# Extract OpenSSL version
OPENSSL_VERSION=$(extract_openssl_version "$OPENSSL_PC_PATH")
if [ -z "$OPENSSL_VERSION" ]; then
    echo "Error: Unable to extract OpenSSL version"
    exit 1
fi

# Extract OTP version
OTP_VERSION=$(extract_otp_version)
if [ -z "$OTP_VERSION" ]; then
    echo "Error: Unable to extract OTP version"
    exit 1
fi

# Find the OTP release directory
OTP_RELEASE_DIR=$(find_otp_release_dir "$OTP_VERSION")
if [ -z "$OTP_RELEASE_DIR" ]; then
    echo "Error: Unable to find OTP release directory"
    exit 1
fi

# Package the build artifacts
echo "Packaging OTP release $OTP_RELEASE_DIR with OpenSSL $OPENSSL_VERSION..."
tar czf otp_${OTP_RELEASE_DIR}_ssl_${OPENSSL_VERSION}.tar.gz -C "./otp_src_${OTP_VERSION}/release" "$OTP_RELEASE_DIR"

echo "Packaging completed."
