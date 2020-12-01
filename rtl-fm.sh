#!/usr/bin/env bash

usage() {
    printf "\n"
    printf "Usage: ./rtl-fm <rtl_fm options> actions \n"
    printf "\n"
    printf "  rtl_fm options:  \n"
    printf "    -f  frequency_to_tune_to [Hz] \n"
    printf "        use multiple -f for scanning (requires squelch) \n"
    printf "        ranges supported, -f 118M:137M:25k \n"
    printf "    [-M modulation (default: fm)] \n"
    printf "        fm, wbfm, raw, am, usb, lsb \n"
    printf "        wbfm == -M fm -s 170k -o 4 -A fast -r 32k -l 0 -E deemp \n"
    printf "        raw mode outputs 2x16 bit IQ pairs \n"
    printf "    [-s sample_rate (default: 24k)] \n"
    printf "    [-d device_index (default: 0)] \n"
    printf "    [-g tuner_gain (default: automatic)] \n"
    printf "    [-l squelch_level (default: 0/off)] \n"
    printf "    [-p ppm_error (default: 0)]"
    printf "\n"
    printf "\n"
    printf "  Actions are: \n"
    printf "    --play                play to the local sound card, requires headphones \n"
    printf "    --stream              stream the sound to the network on port 8080, \n"
    printf "                          runs with 'nohup' on background \n"
    printf "    --sar filename        sound activated recording to a local file, must provide filename \n"
    printf "    --play-sar filename   sound activated recording to a local file with \n"
    printf "                          sound played to the local sound card, \n"
    printf "                          must provide filename and use headphones, \n"
    printf "                          should not use another SDR dongle with --play option \n"
    printf "                          to not mix the sound and trigger recording \n"
    printf "\n"
}

TEMP=$(getopt -o m:f:l:g:p:r:d:h -l play,stream,sar:,play-sar: -n 'rtl-fm' -- "$@")

if [ $? != 0 ]; then echo "Terminating..." >&2 ; exit 1 ; fi

eval set -- "$TEMP"

MODE="fm"
FREQUENCY=
SQUELCH=0
GAIN=0
PPM_ERROR=0
SAMPLE_RATE="24k"
DEVICE=0
FILENAME=
PLAY=false
STREAM=false
SAR=false
PLAY_SAR=false

while true; do
  case "$1" in
    -m ) MODE="$2"; shift 2 ;;
    -f ) FREQUENCY="$2"; shift 2 ;;
    -l ) SQUELCH="$2"; shift 2 ;;
    -g ) GAIN="$2"; shift 2 ;;
    -p ) PPM_ERROR="$2"; shift 2 ;;
    -r ) SAMPLE_RATE="$2"; shift 2 ;;
    -d ) DEVICE="$2"; shift 2 ;;
    -h ) usage; exit 0 ;;
    --sar )
      SAR=true; FILENAME="$2"; shift 2 ;;
    --play-sar )
      PLAY_SAR=true; FILENAME="$2"; shift 2 ;;
    --play )
      PLAY=true; shift ;;
    --stream )
      STREAM=true; shift ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done

RTL_FM_CMD="rtl_fm \
  -M ${MODE} \
  -f ${FREQUENCY} \
  -l ${SQUELCH} \
  -g ${GAIN} \
  -p ${PPM_ERROR} \
  -r ${SAMPLE_RATE} \
  -d ${DEVICE}"

PLAY_CMD="play -t raw -r 24k -e s -b 16 -c 1 -V3 - sinc 400-3000"
STREAM_CMD="cvlc -v - --sout '#standard{access=http,mux=ogg,dst=0.0.0.0:8080}'"
SAR_CMD="sox -t raw -r 24k -e s -b 16 -c 1 -V3 - -t mp3 ${FILENAME}.mp3 sinc 400-3000 silence 1 0.1 1% 1 5.0 1% : newfile : restart &"
PLAY_SAR_CMD="play -t raw -r 24k -e s -b 16 -c 1 -V3 - | rec -t raw -r 24k -e s -b 16 -c 1 -V3 - -t mp3 ${FILENAME}.mp3 sinc 400-3000 silence 1 0.1 1% 1 5.0 1% : newfile : restart"

if [ "$PLAY" = true ]; then
  echo "${RTL_FM_CMD} | ${PLAY_CMD}"
elif [ "$STREAM" = true ]; then
  echo "${RTL_FM_CMD} | ${STREAM_CMD}"
elif [ "$SAR" = true ]; then
  echo "${RTL_FM_CMD} | ${SAR_CMD}"
elif [ "$PLAY_SAR" = true ]; then
  echo "${RTL_FM_CMD} | ${PLAY_SAR_CMD}"
fi
