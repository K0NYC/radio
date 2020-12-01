#!/usr/bin/env bash

TEMP=$(getopt -o m:f:l:g:p:r:d: --long play,stream,sar,play-sar,filename: -n 'rtl-fm' -- "$@")

if ! rtl-fm; then echo "Terminating..." >&2 ; exit 1 ; fi

eval set -- "$TEMP"

MODE="fm"
FREQUENCY=
SQUELCH=0
GAIN=0
ERROR=0
SAMPLE_RATE="24k"
DEVICE=0
FILENAME=
PLAY=false
STREAM=false
SAR=false
PLAY_SAR=false

PLAY_CMD=" | play -t raw -r 24k -e s -b 16 -c 1 -V3 - sinc 400-3000"
STREAM_CMD=" | cvlc -v - --sout '#standard{access=http,mux=ogg,dst=0.0.0.0:8080}'"
SAR_CMD=" | sox -t raw -r 24k -e s -b 16 -c 1 -V3 - -t mp3 ${FILENAME}.mp3 sinc 400-3000 silence 1 0.1 1% 1 5.0 1% : newfile : restart"
PLAY_SAR_CMD=" | play -t raw -r 24k -e s -b 16 -c 1 -V3 - | rec -t raw -r 24k -e s -b 16 -c 1 -V3 - -t mp3 ${FILENAME}.mp3 sinc 400-3000 silence 1 0.1 1% 1 5.0 1% : newfile : restart"

while true; do
  case "$1" in
    -m ) MODE="$2"; shift 2 ;;
    -f ) FREQUENCY="$2"; shift 2 ;;
    -l ) SQUELCH="$2"; shift 2 ;;
    -g ) GAIN="$2"; shift 2 ;;
    -p ) ERROR="$2"; shift 2 ;;
    -r ) SAMPLE_RATE="$2"; shift 2 ;;
    -d ) DEVICE="$2"; shift 2 ;;
    --file-prefix )
      FILENAME="$2"; shift 2 ;;
    --play )
      PLAY=true; shift 2 ;;
    --stream )
      STREAM=true; shift 2 ;;
    --sar )
      SAR=true; shift 2 ;;
    --play-sar )
      PLAY_SAR=true; shift 2 ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done

" rtl_fm -M ${MODE} -f $
