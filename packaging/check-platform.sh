#!/bin/sh
set -eu

EXPECTED_VOLUMIO_VERSION="4.119"
EXPECTED_KERNEL="6.12.74-v7l+"
EXPECTED_MACHINE="armv7l"
EXPECTED_DPKG_ARCH="armhf"
EXPECTED_HARDWARE="pi"
EXPECTED_VOLUMIO_ARCH="arm"

fail()
{
    echo "ERROR: $*" >&2
    exit 1
}

[ -r /etc/os-release ] || fail "/etc/os-release nicht lesbar"

# Volumio stellt diese Werte dort selbst bereit.
. /etc/os-release

[ "${VOLUMIO_VERSION:-}" = "$EXPECTED_VOLUMIO_VERSION" ] ||
    fail "Volumio-Version ${VOLUMIO_VERSION:-unbekannt}; erwartet $EXPECTED_VOLUMIO_VERSION"

[ "${VOLUMIO_HARDWARE:-}" = "$EXPECTED_HARDWARE" ] ||
    fail "Volumio-Hardware ${VOLUMIO_HARDWARE:-unbekannt}; erwartet $EXPECTED_HARDWARE"

[ "${VOLUMIO_ARCH:-}" = "$EXPECTED_VOLUMIO_ARCH" ] ||
    fail "Volumio-Architektur ${VOLUMIO_ARCH:-unbekannt}; erwartet $EXPECTED_VOLUMIO_ARCH"

kernel="$(uname -r)"
[ "$kernel" = "$EXPECTED_KERNEL" ] ||
    fail "Kernel $kernel; erwartet $EXPECTED_KERNEL"

machine="$(uname -m)"
[ "$machine" = "$EXPECTED_MACHINE" ] ||
    fail "Maschine $machine; erwartet $EXPECTED_MACHINE"

dpkg_arch="$(dpkg --print-architecture)"
[ "$dpkg_arch" = "$EXPECTED_DPKG_ARCH" ] ||
    fail "Debian-Architektur $dpkg_arch; erwartet $EXPECTED_DPKG_ARCH"

[ -d "/lib/modules/$EXPECTED_KERNEL" ] ||
    fail "/lib/modules/$EXPECTED_KERNEL fehlt"

echo "OK: kompatible Zielplattform"
echo "Volumio : $VOLUMIO_VERSION"
echo "Hardware: $VOLUMIO_HARDWARE"
echo "Kernel  : $kernel"
echo "Machine : $machine"
echo "dpkg    : $dpkg_arch"
