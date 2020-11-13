# radio

Bluethooth:

`Device 3C:C2:01:91:13:A2 TAOTRONICS SoundSurge 46`
`bluetoothctl disconnect`
`bluetoothctl devices`
`bluetoothctl connect 3C:C2:01:91:13:A2`

FM Radio:
`rtl_fm -M wbfm -f 104.3M -p 43 | play -r 32k -t raw -e s -b 16 -c 1 -V1 -`

Public Services:
`rtl_fm -M fm -f 476.51250M -f 476.46250M -f 476.93750M -f 476.86250M -f 477.01250M -f 476.41250M -f 476.98750M -l 95 -g 40.2 -p 43 -s 30K - | play -r 30k -t raw -e s -b 16 -c 1 -V1 -`

FRS:
`rtl_fm -M fm -f 462.5625M -l 75 -g 38.6 -p 43 -s 30K - | play -r 30k -t raw -e s -b 16 -c 1 -V1 -`
`rtl_fm -M fm -f 462.5500M:467.7250M:125K -l 160 -g 38.6 -p 43 -s 30K - | aplay -r 32000 -f S16_LE -t raw -c 1`

Weather:
`rtl_fm -f 162.400M -f 162.425M -f 162.450M -f 162.475M -f 162.500M -f 162.525M -f 162.550M -l 160 -g 38.6 -p 43 -s 30K - | aplay -r 32000 -f S16_LE -t raw -c 1`
`rtl_fm -f 162.400M:162.550M:25K -l 160 -g 38.6 -p 43 -s 30K - | aplay -r 32000 -f S16_LE -t raw -c 1`
`rtl_fm -f 162.550M -l 60 -g 28 -p 43 -s 30K - | play -r 30k -t raw -e s -b 16 -c 1 -V1 -`

Ham 2m/70cm calling frequencies:
`rtl_fm -M fm -f 146.520M -f 446M -l 100 -g 38.6 -p 43 -s 30K - | play -r 30k -t raw -e s -b 16 -c 1 -V1 -`

Restart GUI:
`systemctl restart gdm`

`rtl_test
Supported gain values (29): 0.0 0.9 1.4 2.7 3.7 7.7 8.7 12.5 14.4 15.7 16.6 19.7 20.7 22.9 25.4 28.0 29.7 32.8 33.8 36.4 37.2 38.6 40.2 42.1 43.4 43.9 44.5 48.0 49.6`
`rtl_test -p` to find out offset in ppm

RTL SDR frequency correction: https://davidnelson.me/?p=371

Camera rotation:
"v4l2-ctl --set-ctrl=rotate=90"
https://www.raspberrypi.org/forums/viewtopic.php?t=273811


Steps for Configuring Mate Desktop on 4GB Raspberry Pi 4B:
https://www.raspberrypi.org/forums/viewtopic.php?t=260974
