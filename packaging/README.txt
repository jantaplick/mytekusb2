Mytek Stereo192-DSD USB2 - private Volumio package
==================================================

Tested platform:
- Volumio 4.204
- Raspberry Pi
- armv7l / armhf
- Kernel 6.12.75-v7l+

Driver source (unchanged from the previous validated release):
- Commit e17a0458a45d520618cd06bc5614283a3a5ecb4b
- Historical driver tag volumio-4.119-mytek-usb2-v1

Kernel/build provenance for this package:
- Raspberry Pi Linux commit 89050b1059997d38d55462b323b099a6436dc10d
- Raspberry Pi firmware commit 98655d3ccedba33aeadd0e550229f1496c5bf6f9
- Module SHA256 b3bd54d5ebd47c22f1636e04b483bfd9014c6730c8b628ac970fa54183269965

Validated:
- automatic multi-stage firmware loading after DAC power-on
- ALSA device: Mytek Stereo192-DSD USB2
- Volumio playback at 44.1 kHz
- Volumio playback at 192 kHz
- sample-rate changes 44.1 -> 192 -> 44.1 kHz
- no XRUN or new USB errors after successful initialization
- module auto-load after clean reboot

Known hardware/firmware limitation:
(observed and documented on the previous release; keep this operational rule)
If the Raspberry Pi is rebooted while an already initialized Mytek remains
powered on, the DAC can enter the state:

  Pre-initialised Mytek with missing FPGA firmware

In that case power-cycle the Mytek DAC. A Pi reboot is not required.

Recommended startup sequence:
1. Boot Volumio.
2. Power on the Mytek.
3. Wait for firmware initialization / 88.2 display.
