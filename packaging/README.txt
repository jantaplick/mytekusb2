Mytek Stereo192-DSD USB2 - private Volumio package
==================================================

Tested platform:
- Volumio 4.119
- Raspberry Pi
- armv7l / armhf
- Kernel 6.12.74-v7l+

Driver source:
- Commit e17a0458a45d520618cd06bc5614283a3a5ecb4b
- Tag volumio-4.119-mytek-usb2-v1

Validated:
- automatic multi-stage firmware loading after DAC power-on
- ALSA device: Mytek Stereo192-DSD USB2
- Volumio playback at 44.1 kHz
- Volumio playback at 192 kHz
- sample-rate changes 44.1 -> 192 -> 44.1 kHz
- no XRUN or new USB errors after successful initialization

Known hardware/firmware limitation:
If the Raspberry Pi is rebooted while an already initialized Mytek remains
powered on, the DAC can enter the state:

  Pre-initialised Mytek with missing FPGA firmware

In that case power-cycle the Mytek DAC. A Pi reboot is not required.

Recommended startup sequence:
1. Boot Volumio.
2. Power on the Mytek.
3. Wait for firmware initialization / 88.2 display.
