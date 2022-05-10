#!/bin/sh

set -euo pipefail

files=(
	assets/images/sleep-orig/*
)
for source in ${files[@]}; do
	dest=$source
	dest=${dest//sleep-orig/sleep}
	dest=${dest%.*}
	echo "$source -> $dest"
	resize="-resize 720x>"
	quality="-quality 45"
	if [[ "$source" =~ "roles-in-society" ]]; then
		cp $source $dest.gif
		continue
	fi
	if [[ "$source" =~ "hannah-mumby" ]]; then
		resize=""
	fi
	convert \
		$source \
		-format webp \
		$resize \
		$quality \
		$dest.webp
done
