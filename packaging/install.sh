#!/bin/sh
set -eu

EXPECTED_VERMAGIC="6.12.74-v7l+ SMP mod_unload modversions ARMv7 p2v8"
EXPECTED_MODULE_SHA256="176db6a8bf1a5e72a6aed3be6baf917aa1dedb9e0e2673c11f66637079604601"

EXPECTED_MYTEKAP_SHA256="76e05f7f7602997a0de9e0371201349f1904f6d75f1ffe920367fd329a14c041"
EXPECTED_MYTEKCF_SHA256="4e2158606cffa41e24657e97a526e26b218b0334cc2c76465389d5b6e2013127"
EXPECTED_MYTEKL2_SHA256="ab09812dba64002bd220626febf58501adc3b00f5e3b8e76c46f083357e68d35"

SCRIPT_DIR=$(CDPATH= cd "$(dirname "$0")" && pwd)

fail()
{
    echo "ERROR: $*" >&2
    exit 1
}

check_hash()
{
    expected="$1"
    file="$2"

    [ -f "$file" ] || fail "Datei fehlt: $file"

    actual=$(sha256sum "$file" | awk '{print $1}')
    [ "$actual" = "$expected" ] ||
        fail "SHA256 stimmt nicht: $file"
}

echo "=== Plattform ==="
"$SCRIPT_DIR/check-platform.sh"

echo
echo "=== Paketdateien ==="

check_hash "$EXPECTED_MODULE_SHA256" \
    "$SCRIPT_DIR/module/snd-usb-mytek.ko"

check_hash "$EXPECTED_MYTEKAP_SHA256" \
    "$SCRIPT_DIR/firmware/mytek/mytekap.ihx"

check_hash "$EXPECTED_MYTEKCF_SHA256" \
    "$SCRIPT_DIR/firmware/mytek/mytekcf.bin"

check_hash "$EXPECTED_MYTEKL2_SHA256" \
    "$SCRIPT_DIR/firmware/mytek/mytekl2.ihx"

echo "OK: alle SHA256-Prüfsummen stimmen"

echo
echo "=== Kernelmodul ==="

ACTUAL_VERMAGIC=$(/sbin/modinfo -F vermagic \
    "$SCRIPT_DIR/module/snd-usb-mytek.ko" | sed 's/[[:space:]]*$//')

[ "$ACTUAL_VERMAGIC" = "$EXPECTED_VERMAGIC" ] ||
    fail "vermagic '$ACTUAL_VERMAGIC'; erwartet '$EXPECTED_VERMAGIC'"

echo "OK: vermagic stimmt"
echo "$ACTUAL_VERMAGIC"

if [ "${1:-}" = "--check" ]; then
    echo
    echo "PRECHECK OK - keine Systemdateien wurden verändert."
    exit 0
fi

[ "$(id -u)" -eq 0 ] ||
    fail "Installation muss als root ausgeführt werden"

echo
echo "=== Installation ==="

mkdir -p /lib/modules/6.12.74-v7l+/extra
mkdir -p /lib/firmware/mytek

install -m 0644 \
    "$SCRIPT_DIR/module/snd-usb-mytek.ko" \
    /lib/modules/6.12.74-v7l+/extra/snd-usb-mytek.ko

install -m 0644 \
    "$SCRIPT_DIR/firmware/mytek/mytekap.ihx" \
    "$SCRIPT_DIR/firmware/mytek/mytekcf.bin" \
    "$SCRIPT_DIR/firmware/mytek/mytekl2.ihx" \
    /lib/firmware/mytek/

depmod -a

echo
echo "Installation abgeschlossen."
echo "Hinweis: Ein bereits geladenes snd_usb_mytek wird nicht zwangsweise ersetzt."
echo "Für einen sauberen Neustart: Mytek ausschalten, Pi booten lassen, Mytek einschalten."
