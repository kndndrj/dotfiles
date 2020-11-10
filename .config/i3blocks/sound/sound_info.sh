#!/bin/sh

VOLUME_MUTE="\uf6a9"
VOLUME_LOW="\uf026"
VOLUME_MID="\uf027"
VOLUME_HIGH="\uf028"
SOUND_LEVEL=$(amixer get Master | awk -F"[][]" '/%/ { print $2 }' | awk -F"%" 'BEGIN{tot=0; i=0} {i++; tot+=$1} END{printf("%s\n", tot/i) }')
MUTED=$(amixer get Master | awk ' /%/{print ($NF=="[off]" ? 1 : 0); exit;}')

ICON=$VOLUME_MUTE
if [ "$MUTED" = "1" ]
then
    ICON="$VOLUME_MUTE"
else
    if [ "$SOUND_LEVEL" -lt 34 ]
    then
        ICON="$VOLUME_LOW"
    elif [ "$SOUND_LEVEL" -lt 67 ]
    then
        ICON="$VOLUME_MID"
    else
        ICON="$VOLUME_HIGH"
    fi
fi

echo -e "$ICON" "$SOUND_LEVEL" | awk '{ printf(" %s %2s%% \n", $1, $2) }'

