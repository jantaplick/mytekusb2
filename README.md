# mytekusb2

Linux ALSA USB driver for the **Mytek Digital Stereo192-DSD DAC** using its proprietary USB2 interface.

This fork continues the original `lintweaker/mytekusb2` project and preserves its full Git history. The driver was adapted for Mytek by **Jurgen Kramer** and is based on the TerraTec DMX 6Fire USB driver by **Torsten Schenk**. See [AUTHORS.md](AUTHORS.md) for project provenance and additional contributors.

## Current maintained state

The maintained branch includes recent-kernel compatibility work and a fix for the Mytek multi-stage firmware re-probe sequence after USB re-enumeration.

Validated configuration:

- Raspberry Pi 4
- Volumio 4.119
- Linux `6.12.74-v7l+` (`armv7l` / `armhf`)
- Mytek USB firmware reported by the device as `3.1.35`
- playback validated at 44.1 kHz and 192 kHz
- rate switching validated 44.1 -> 192 -> 44.1 kHz
- direct ALSA playback validated at 192 kHz / S32_LE

The Volumio-specific packaging files in `packaging/` are intentionally tied to the exact tested platform. Do not force-install a kernel module built for a different kernel.

## Features

- automatic multi-stage firmware loading
- ALSA PCM playback
- `S24_LE` and `S32_LE`
- sample rates 44.1, 48, 88.2, 96, 176.4 and 192 kHz
- DoP support as provided by the original driver/data path
- no USB mixer control

The device transports more proprietary USB channels internally than the exposed ALSA playback interface; that behavior is inherited from the original driver design.

## Proprietary firmware is not distributed here

The driver requires three Mytek firmware files at runtime:

- `mytekl2.ihx`
- `mytekcf.bin`
- `mytekap.ihx`

They are proprietary and are **not included in this repository or public releases**. Device owners must obtain them lawfully from their own Mytek driver/firmware package and install them locally under:

```text
/lib/firmware/mytek/
```

See [FIRMWARE](FIRMWARE) for the currently validated SHA256 values and installation notes.

## Important startup limitation

A cold DAC power-on after the Raspberry Pi / host has booted is the recommended sequence.

If the host is rebooted while an already initialized Mytek remains powered on, the original firmware state machine can report:

```text
Pre-initialised Mytek with missing FPGA firmware
```

In that state, power-cycle the Mytek DAC. With the maintained re-probe fix, the firmware sequence should then continue automatically; a second host reboot or manual module reload is not required.

## Build

This is an out-of-tree kernel module. Build it against the **exact headers/source tree and symbol versions for the running kernel**.

A typical build remains:

```sh
make
```

On distributions with non-default kernel build trees or compilers, pass the appropriate kernel/build variables explicitly. The Volumio 4.119 validation used the exact Raspberry Pi kernel source corresponding to `6.12.74-v7l+`.

## Verify

After successful initialization, ALSA should show a card similar to:

```text
USB2 [Mytek Stereo192-DSD USB2]
```

A direct playback test can use ALSA, for example:

```sh
aplay -D hw:CARD=USB2,DEV=0 -t raw -f S32_LE -c 2 -r 192000 -d 10 /dev/zero
```

## License and attribution

The source files retain their original copyright and GPL notices. In particular, the Mytek adaptation source states GPL version 2 or, at the user's option, any later version.

This fork does not rewrite historical authorship. See [AUTHORS.md](AUTHORS.md) and the Git history for provenance.

## Historical documentation

The original `INSTALL`, `ISSUES` and repository history are retained because they document device behavior and earlier supported environments. Some historical instructions refer to old kernels and old Mytek firmware packages; prefer the maintained notes above for the current tested setup.
