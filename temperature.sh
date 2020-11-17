#!/bin/bash
Temp=$(cat /sys/class/thermal/thermal_zone0/temp)
echo $(( $Temp / 1000))
