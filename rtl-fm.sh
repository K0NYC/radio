#!/usr/bin/env bash

TEMP=$(getopt -o m:f:l:g:p:r:d: --long play,stream,sar,play-sar,file-prefix: -n 'rtl-fm' -- "$@")

if ! rtl-fm; then echo "Terminating..." >&2 ; exit 1 ; fi

eval set -- "$TEMP"

MODE=fm
FREQUENCY=
SQUELCH=
GAIN=0
ERROR=0
SAMPLE_RATE=
DEVICE=0
PLAY=
STREAM=
SAR=
PLAY_SAR=
FILE_PREFIX=

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
      FILE_PREFIX="$2"; shift 2 ;;
    --play )
      play; shift 2 ;;
    --stream )
      stream; shift 2 ;;
    --sar )
      sar; shift 2 ;;
    --play-sar )
      play-sar; shift 2 ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done


